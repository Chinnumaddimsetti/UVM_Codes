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
 module top();
	import uvm_pkg::*;
   write_xtn wr_copy_xtnh,wr_clone_xtnh;
   write_xtn wr_xtnh[];
   int no_trans=10;
	initial begin
      wr_xtnh=new[10];

      for(int i=0;i<no_trans;i++) begin
         wr_xtnh[i]=write_xtn::type_id::create($sformatf("wr_xtnh[%0d]",i));
         wr_xtnh[i].randomize();
         wr_xtnh[i].print();
      end	
	  wr_xtnh[3].copy(wr_xtnh[5]);
      wr_xtnh[3].print();
      wr_xtnh[5].print();

      wr_copy_xtnh=write_xtn::type_id::create("wr_copy_xtnh");
      wr_copy_xtnh.copy(wr_xtnh[3]);
      wr_copy_xtnh.print(uvm_default_tree_printer);
	   if(wr_xtnh[3].compare(wr_xtnh[5]))
         $display("SUCCESSFUL");
      else 
         $display("NOT SUCCESSFUL");

      $cast(wr_clone_xtnh,wr_xtnh[7].clone());
      wr_clone_xtnh.print(uvm_default_line_printer);
   end
endmodule : top
