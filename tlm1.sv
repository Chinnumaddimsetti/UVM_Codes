import uvm_pkg::*;
	`include "uvm_macros.svh"
// transaction class 
class write_xtn extends uvm_sequence_item;
	rand bit [7:0] addr;
  rand bit [7:0] data;

  `uvm_object_utils(write_xtn)

  function new(string name = "write_xtn");
    super.new(name);
  endfunction
endclass
// generator 
class gen extends uvm_component;
	`uvm_component_utils(gen)
	uvm_blocking_put_port #(write_xtn)pp;
	function new(string name,uvm_component parent);
		super.new(name,parent);
		pp=new("pp",this);
	endfunction
	virtual task run_phase(uvm_phase phase);
		write_xtn xtn=write_xtn::type_id::create("xtn");
		assert(xtn.randomize());
		`uvm_info("GEN", $sformatf("gen transaction: addr=0x%0h, data=0x%0h", xtn.addr, xtn.data), UVM_MEDIUM);
		pp.put(xtn);
	endtask
endclass
// driver 
class drv extends uvm_component;
	`uvm_component_utils(drv)
	uvm_blocking_get_port #(write_xtn)gp;
	uvm_blocking_put_port #(write_xtn)pp;
	function new(string name,uvm_component parent);
		super.new(name,parent);
		gp=new("gp",this);
		pp=new("pp",this);
	endfunction
	virtual task run_phase(uvm_phase phase);
		write_xtn xtn=write_xtn::type_id::create("xtn");
	//	assert(xtn.randomize());
		`uvm_info("Drv", $sformatf("Driver transaction: addr=0x%0h, data=0x%0h", xtn.addr, xtn.data), UVM_MEDIUM);
		gp.get(xtn);
	endtask
endclass


// agent
class agt extends uvm_component;
	`uvm_component_utils(agt)
	//uvm_blocking_put_port #(write_xtn)pp;
	uvm_blocking_get_port #(write_xtn)gp;
	function new(string name,uvm_component parent);
		super.new(name,parent);
	//	pp=new("pp",this);
		gp=new("gp",this);
	endfunction
	virtual task run_phase(uvm_phase phase);
		write_xtn xtn=write_xtn::type_id::create("xtn");
	//	assert(xtn.randomize());
		`uvm_info("agt", $sformatf("Agent transaction: addr=0x%0h, data=0x%0h", xtn.addr, xtn.data), UVM_MEDIUM);
		gp.get(xtn);
	endtask
endclass
class agent1 extends uvm_component;
  `uvm_component_utils(agent1)
 // uvm_blocking_get_port #(write_xtn)gp;
  uvm_blocking_put_port #(write_xtn)pp;
	/*function new(string name,uvm_component parent);
		super.new(name,parent);
		gp=new("gp",this);
	endfunction*/

  drv drvh;
  gen genh;
  uvm_tlm_fifo #(write_xtn) fifoh;

  function new(string name, uvm_component parent);
    super.new(name, parent);
//	gp=new("gp",this);
	pp=new("pp",this);
	genh = gen::type_id::create("genh", this);
	drvh = drv::type_id::create("drvh", this);
    fifoh = new("fifoh", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    genh.pp.connect(fifoh.put_export);
	drvh.gp.connect(fifoh.get_export);
	drvh.pp.connect(this.pp);
  endfunction
endclass

// agent 2

class agent2 extends uvm_component;
  `uvm_component_utils(agent2)
 // uvm_blocking_get_port #(write_xtn)gp;
  uvm_blocking_put_export #(write_xtn)pe;
 //uvm_blocking_get_export #(write_xtn)ge;

  uvm_tlm_fifo #(write_xtn) fifoh;

  agt agth;

  function new(string name, uvm_component parent);
    super.new(name, parent);
	fifoh = new("fifoh", this);

//	gp=new("gp",this);
	pe=new("pe",this);
//	ge=new("ge",this);

   agth = agt::type_id::create("agth", this);
	
  endfunction
           
  function void connect_phase(uvm_phase phase);
    agth.gp.connect(fifoh.get_export);// gp to this.ge
    this.pe.connect(fifoh.put_export);
  endfunction
endclass


// agent 3

class agent3 extends uvm_test;
  `uvm_component_utils(agent3)
//uvm_blocking_put_export #(write_xtn)pe;

  agent1 h1;
  agent2 h2;
 // uvm_tlm_fifo #(write_xtn) fifoh;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    h1 = agent1::type_id::create("h1", this);
    h2 = agent2::type_id::create("h2", this);
//	pe = new("pe", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    h1.pp.connect(h2.pe);
//	h2.gp.connect(fifoh.get_export);
  endfunction
endclass

// Top Module
module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  initial begin
    run_test("agent3");
  end
endmodule

