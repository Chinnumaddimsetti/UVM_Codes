import uvm_pkg::*;
`include "uvm_macros.svh"

// Transaction Class
class write_xtn extends uvm_sequence_item;
  rand bit [7:0] addr;
  rand bit [7:0] data;

  `uvm_object_utils(write_xtn)

  function new(string name = "write_xtn");
    super.new(name);
  endfunction
endclass

// Generator Class
class gen extends uvm_component;
  `uvm_component_utils(gen)

  uvm_blocking_put_port #(write_xtn) pp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    pp = new("pp", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    write_xtn xtn = write_xtn::type_id::create("xtn");
    assert(xtn.randomize());
    `uvm_info("GEN", $sformatf("Generated transaction: addr=0x%0h, data=0x%0h", xtn.addr, xtn.data), UVM_MEDIUM);
    pp.put(xtn);
  endtask
endclass

// Driver Class
class drv extends uvm_component;
  `uvm_component_utils(drv)

  uvm_blocking_put_imp #(write_xtn, drv) pi;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    pi = new("pi", this);
  endfunction

  virtual task put(write_xtn xtn_h);
    `uvm_info("DRV", $sformatf("Received transaction: addr=0x%0h, data=0x%0h", xtn_h.addr, xtn_h.data), UVM_MEDIUM);
  endtask
endclass

// Intermediate Component Class - c4
class c4 extends uvm_component;
  `uvm_component_utils(c4)

  gen genh;
  uvm_blocking_put_port #(write_xtn) pp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    genh = gen::type_id::create("genh", this);
    pp = new("pp", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    genh.pp.connect(this.pp);
  endfunction
endclass

// Intermediate Component Class - c2
class c2 extends uvm_component;
  `uvm_component_utils(c2)

  c4 c4h;
  uvm_blocking_put_port #(write_xtn) pp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    c4h = c4::type_id::create("c4h", this);
    pp = new("pp", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    c4h.pp.connect(this.pp);
  endfunction
endclass

// Intermediate Component Class - c5
class c5 extends uvm_component;
  `uvm_component_utils(c5)

  drv drvh;
  uvm_blocking_put_port #(write_xtn) pp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    drvh = drv::type_id::create("drvh", this);
    pp = new("pp", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    this.pp.connect(drvh.pi);
  endfunction
endclass

// Intermediate Component Class - c3
class c3 extends uvm_component;
  `uvm_component_utils(c3)

  c5 c5h;
  uvm_blocking_put_port #(write_xtn) pp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    c5h = c5::type_id::create("c5h", this);
    pp = new("pp", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    this.pp.connect(c5h.pp);
  endfunction
endclass

// Top-Level Component Class - c1
class c1 extends uvm_component;
  `uvm_component_utils(c1)

  c2 c2h;
  c3 c3h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    c2h = c2::type_id::create("c2h", this);
    c3h = c3::type_id::create("c3h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    c2h.pp.connect(c3h.pp);
  endfunction
endclass

// Top Module
module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  initial begin
    run_test("c1");
  end
endmodule
