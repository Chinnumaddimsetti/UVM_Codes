import uvm_pkg::*;
	`include "uvm_macros.svh"
class write_xtn extends uvm_sequence_item;	
	`uvm_object_utils(write_xtn)
	typedef enum bit {bad_xtn,good_xtn}addr_t;
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
	// do copy 
	function void do_copy(uvm_object rhs);
		write_xtn rhs_;
		if(!$cast(rhs_,rhs)) begin 
			`uvm_fatal("do_copy ","cast is failed")
		end 
		super.do_copy(rhs);
		this.data=rhs_.data;
		this.address=rhs_.address;
		this.write=rhs_.write;
		this.xtn_type=rhs_.xtn_type;
		this.xtn_delay=rhs_.xtn_delay;
	endfunction 
	// do compare
	function bit do_compare(uvm_object rhs,uvm_comparer comparer);
		write_xtn rhs_;
		if(!$cast(rhs_,rhs)) begin 
			`uvm_error("do_compare","cast is failed");
			return 0;
		end 
		return 
		super.do_compare(rhs,comparer) &&
		(this.data==rhs_.data) &&
		(this.address==rhs_.address) &&
		(this.write==rhs_.write) &&
		(this.xtn_type==rhs_.xtn_type) &&
		(this.xtn_delay==rhs_.xtn_delay);
	endfunction
	function void do_print(uvm_printer printer);
      super.do_print(printer);
      printer.print_field("data", this.data, $bits(this.data), UVM_DEC);
      printer.print_field("address", this.address, $bits(this.address), UVM_DEC);
      printer.print_field("write", this.write, 1, UVM_DEC);
      printer.print_field("xtn_delay", this.xtn_delay, $bits(this.xtn_delay), UVM_DEC);
      printer.print_generic("xtn_type", "addr_t", $bits(this.xtn_type), this.xtn_type.name());
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