`include "uvm_macros.svh"
import uvm_pkg::*;

// Monitor
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Driver
class my_driver extends uvm_driver;
    `uvm_component_utils(my_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Sequencer
class my_sequencer extends uvm_sequencer;
    `uvm_component_utils(my_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Agent
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)

    my_driver drv;
    my_monitor mon;
    my_sequencer seqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = my_driver::type_id::create("drv", this);
        mon = my_monitor::type_id::create("mon", this);
        seqr = my_sequencer::type_id::create("seqr", this);
    endfunction
endclass

// Environment
class my_env extends uvm_env;
    `uvm_component_utils(my_env)

    my_agent agt;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = my_agent::type_id::create("agt", this);
    endfunction
endclass

// Test
class my_test extends uvm_test;
    `uvm_component_utils(my_test)

    my_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology(); // Print UVM topology
    endfunction
endclass

// Top Module
module top;
    initial begin
        run_test("my_test");
    end
endmodule
