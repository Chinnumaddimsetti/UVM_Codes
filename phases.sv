// with macros 

import uvm_pkg::*;
	`include "uvm_macros.svh"
class write_xtn extends uvm_sequence_item;	
typedef enum bit {bad_xtn,good_xtn}addr_t;
	`uvm_object_utils_begin(write_xtn)
		`uvm_field_int(data,UVM_ALL_ON)
		`uvm_field_int(address,UVM_ALL_ON)
		`uvm_field_int(write,UVM_ALL_ON)
		`uvm_field_enum(addr_t,xtn_type,UVM_ALL_ON)
		`uvm_field_int(xtn_delay,UVM_ALL_ON)
`uvm_object_utils_end
	/*typedef uvm_object_registry #(write_xtn)type_id;
		static function type_id get_type();
			return type_id::get();
		endfunction
		function string get_type_name();
			return "write_xtn";
		endfunction*/
	
	
	rand bit [63:0]data;
	rand bit [11:0]address;
	rand bit write;
	rand addr_t xtn_type;
	rand int xtn_delay;
	
	constraint c1{ data inside {[20:90]};}
	constraint c2{ address inside {[0:200]};}
	constraint c3{xtn_type dist {bad_xtn :=2,good_xtn :=30};}
	
	function new(string name="write_xtn");
		super.new(name);
	endfunction
	function void post_randomize();
      if (xtn_type == bad_xtn)
         address = 6000;
   endfunction
 endclass
 
 //    wr driver  
 
 class ram_wr_driver extends uvm_driver;

   `uvm_component_utils(ram_wr_driver)

	extern function new(string name = "ram_wr_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void extract_phase(uvm_phase phase);
	extern function void check_phase(uvm_phase phase);
	extern function void report_phase(uvm_phase phase);

endclass

function ram_wr_driver::new(string name="ram_wr_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void ram_wr_driver:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("RAM_DRIVER","This is build phase",UVM_LOW)
endfunction

function void ram_wr_driver:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("RAM_DRIVER","This is connect phase",UVM_LOW)
endfunction

function void ram_wr_driver:: end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	`uvm_info("RAM_DRIVER","This is end_of_elaboration phase",UVM_LOW)
endfunction

function void ram_wr_driver:: start_of_simulation_phase(uvm_phase phase);
	super.start_of_simulation_phase(phase);
	`uvm_info("RAM_DRIVER","This is start_of_simulation_phase",UVM_LOW)
endfunction

task ram_wr_driver:: run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#10;
	phase.drop_objection(this);
	`uvm_info("RAM_DRIVER","This is run_phase",UVM_LOW)
endtask

function void ram_wr_driver:: extract_phase(uvm_phase phase);
	super.extract_phase(phase);
	`uvm_info("RAM_DRIVER","This is extract_phase",UVM_LOW)
endfunction

function void ram_wr_driver:: check_phase(uvm_phase phase);
	super.check_phase(phase);
	`uvm_info("RAM_DRIVER","This is check_phase",UVM_LOW)
endfunction

function void ram_wr_driver::report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("RAM_DRIVER","This is report_phase",UVM_MEDIUM)
endfunction

//      wr agent  

class ram_wr_agent extends uvm_agent;

   `uvm_component_utils(ram_wr_agent)	

	ram_wr_driver drvh;

	extern function new(string name = "ram_wr_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void extract_phase(uvm_phase phase);
	extern function void check_phase(uvm_phase phase);
	extern function void report_phase(uvm_phase phase);

endclass

function ram_wr_agent ::new(string name="ram_wr_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void ram_wr_agent :: build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("RAM_AGENT","This is build phase",UVM_LOW)
endfunction

function void ram_wr_agent :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("RAM_AGENT","This is connect phase",UVM_LOW)
endfunction

function void ram_wr_agent :: end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	`uvm_info("RAM_AGENT","This is end_of_elaboration phase",UVM_LOW)
endfunction

function void ram_wr_agent :: start_of_simulation_phase(uvm_phase phase);
	super.start_of_simulation_phase(phase);
	`uvm_info("RAM_AGENT","This is start_of_simulation_phase",UVM_LOW)
endfunction

task ram_wr_agent ::  run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#100;
	phase.drop_objection(this);
	`uvm_info("RAM_AGENT","This is run_phase",UVM_LOW)
endtask

function void ram_wr_agent :: extract_phase(uvm_phase phase);
	super.extract_phase(phase);	
	`uvm_info("RAM_AGENT","This is extract_phase",UVM_LOW)
endfunction

function void ram_wr_agent :: check_phase(uvm_phase phase);
	super.check_phase(phase);
	`uvm_info("RAM_AGENT","This is check_phase",UVM_LOW)
endfunction

function void ram_wr_agent :: report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("RAM_AGENT","This is report_phase",UVM_LOW)
endfunction


//   env 

class ram_env extends uvm_env;

   `uvm_component_utils(ram_env)

	ram_wr_agent drv2h;

	extern function new(string name = "ram_env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void extract_phase(uvm_phase phase);
	extern function void check_phase(uvm_phase phase);
	extern function void report_phase(uvm_phase phase);

endclass
	
function ram_env::new(string name="ram_env",uvm_component parent);
	super.new(name,parent);
endfunction

function void ram_env:: build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("RAM_ENV", "This is build phase", UVM_LOW)
	drv2h = ram_wr_agent::type_id::create("env", this);
endfunction

function void ram_env:: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("RAM_ENV", "This is connect phase", UVM_LOW)
endfunction

function void ram_env:: end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	`uvm_info("RAM_ENV", "This is end_of_elaboration phase", UVM_LOW)
endfunction

function void ram_env:: start_of_simulation_phase(uvm_phase phase);
	super.start_of_simulation_phase(phase);
	`uvm_info("RAM_ENV", "This is start_of_simulation phase", UVM_LOW)
endfunction

task ram_env:: run_phase(uvm_phase phase);
	`uvm_info("RAM_ENV", "This is run phase - raising objection", UVM_LOW)
	phase.raise_objection(this);
	#100;
	`uvm_info("RAM_ENV", "This is run phase - dropping objection", UVM_LOW)
	phase.drop_objection(this);
endtask

function void ram_env::extract_phase(uvm_phase phase);
	super.extract_phase(phase);
	`uvm_info("RAM_ENV", "This is extract phase", UVM_LOW)
endfunction

function void ram_env:: check_phase(uvm_phase phase);
	super.check_phase(phase);
	`uvm_info("RAM_ENV", "This is check phase", UVM_LOW)
endfunction

function void ram_env:: report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("RAM_ENV", "This is report phase", UVM_LOW)
endfunction

// wr test 

class ram_wr_test extends uvm_test;

   `uvm_component_utils(ram_wr_test)

   ram_env env;

   extern function new(string name = "ram_wr_test",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   extern function void end_of_elaboration_phase(uvm_phase phase);
   extern function void start_of_simulation_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   extern function void extract_phase(uvm_phase phase);
   extern function void check_phase(uvm_phase phase);
   extern function void report_phase(uvm_phase phase);
 
endclass

function ram_wr_test :: new(string name = "ram_wr_test", uvm_component parent);
	super.new(name, parent);
endfunction

function void  ram_wr_test ::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is build phase", UVM_LOW)
	env = ram_env::type_id::create("env", this);
endfunction

function void   ram_wr_test :: connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is connect phase", UVM_LOW)
endfunction

function void  ram_wr_test ::  end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is end_of_elaboration phase", UVM_LOW)
endfunction

function void  ram_wr_test ::  start_of_simulation_phase(uvm_phase phase);
	super.start_of_simulation_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is start_of_simulation phase", UVM_LOW)
endfunction

task  ram_wr_test :: run_phase(uvm_phase phase);
	`uvm_info("RAM_WR_TEST", "This is run phase - raising objection", UVM_LOW)
	phase.raise_objection(this);
	#100;
	`uvm_info("RAM_WR_TEST", "This is run phase - dropping objection", UVM_LOW)
	phase.drop_objection(this);
endtask

function void  ram_wr_test :: extract_phase(uvm_phase phase);
	super.extract_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is extract phase", UVM_LOW)
endfunction

function void  ram_wr_test :: check_phase(uvm_phase phase);
	super.check_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is check phase", UVM_LOW)
endfunction

function void  ram_wr_test :: report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("RAM_WR_TEST", "This is report phase", UVM_LOW)
endfunction
//  top 
module top;

   // import ram_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    initial
    begin
        run_test("ram_wr_test");
    end 

endmodule : top
