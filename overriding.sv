import uvm_pkg::*;
`include "uvm_macros.svh"

class write_xtn extends uvm_sequence_item;	

    typedef enum bit {bad_xtn, good_xtn} addr_t;

    `uvm_object_utils_begin(write_xtn)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(address, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_enum(addr_t, xtn_type, UVM_ALL_ON)
        `uvm_field_int(xtn_delay, UVM_ALL_ON)
    `uvm_object_utils_end

    rand bit [63:0] data;
    rand bit [11:0] address;
    rand bit write;
    rand addr_t xtn_type;
    rand int xtn_delay;
	
    constraint c1 { data inside {[20:90]}; }
    constraint c2 { address inside {[0:200]}; }
    constraint c3 { xtn_type dist {bad_xtn := 2, good_xtn := 30}; }
	
    function new(string name = "write_xtn");
        super.new(name);
    endfunction

    function void post_randomize();
        if (xtn_type == bad_xtn) begin
            address = 6000;
        end
    endfunction
endclass

class short_xtn extends write_xtn;

    `uvm_object_utils(short_xtn)

    constraint addr_name { address inside {[0:15]}; }

    function short_xtn::new(string name = "short_xtn");
        super.new(name);
    endfunction
endclass

module top;

    import uvm_pkg::*;
    write_xtn wr_xtnh;

    function void build();
        wr_xtnh = write_xtn::type_id::create("wr_xtnh");
        assert(wr_xtnh.randomize());
        wr_xtnh.print();
    endfunction

    initial begin
        uvm_factory factory = uvm_factory::get();

        for (int i = 0; i < 2; i++) 
            build();

        factory.set_type_override_by_type(write_xtn::get_type(), short_xtn::get_type(), 1);

        for (int i = 0; i < 2; i++)
            build();
    end
endmodule
