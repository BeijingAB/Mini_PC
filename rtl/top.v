`include "lb.v"

module top(
    input rst_n,
    input clk,


    output reg [3:0] leds
);

//// CPU Specification
`define XPRLEN 32

wire [`XPRLEN-1:0] x0 = `XPRLEN'b0;
reg [`XPRLEN-1:0] x [31:0];

reg [`XPRLEN-1:0] f0;
reg [`XPRLEN-1:0] f1;
reg [`XPRLEN-1:0] f2;
reg [`XPRLEN-1:0] f3;
reg [`XPRLEN-1:0] f4;
reg [`XPRLEN-1:0] f5;
reg [`XPRLEN-1:0] f6;
reg [`XPRLEN-1:0] f7;

reg [`XPRLEN-1:0] pc;
reg [`XPRLEN-1:0] fsr;


// test ram 

// input	[7:0]  address;
// input	  clock;
// input	[7:0]  data;
// input	  wren;
// output	[7:0]  q;

// reg	[7:0]  ram_address;
// reg	ram_clock;
// reg	[7:0]  ram_data;
// reg	ram_wren;
// wire	[7:0]  ram_q;

// ram	ram_inst (
// 	.address ( ram_address ),
// 	.clock ( clk ),
// 	.data ( ram_data ),
// 	.wren ( ram_wren ),
// 	.q ( ram_q )
// 	);

wire en = 1;
wire [`XPRLEN-1:0] rd_value = 1;
wire [11:7] imm1 = 0;
wire [6:0] imm2 = 2;

wire [`XPRLEN-1:0] rs1_value;
wire done;

lb lb_inst(
    .clk (clk),
    .rst_n (leds[0]),

    .en (en),
    // value that rd register stores, not the index number of rd register
    .rd_value (rd_value),
    .imm1 (imm1),
    .imm2 (imm2),
    // value that rs1 (actual memory value) register stores, not the index number of rs1 register
    .rs1_value (rs1_value),
    .done (done)
);

// always @(posedge clk) begin
//     if (!rst_n) begin
//         ram_address <= 8'b0;
//         ram_data <= 8'b0;
//         ram_wren <= 0;
//     end else begin
//         ram_address <= ram_address + 1;

//         if (ram_wren == 1)
//             ram_data <= ram_address + 1;
//         else
//             ram_data <= 8'b0;

//         if (ram_address == 8'b1111_1111)
//             ram_wren <= ~ram_wren;
//         else
//             ram_wren <= ram_wren;
//     end    
// end

// test rom

// input	[7:0]  address;
// input	  clock;
// output	[7:0]  q;

reg [7:0] rom_address;
wire [7:0] rom_q;

rom	rom_inst (
	.address ( rom_address ),
	.clock ( clk ),
	.q ( rom_q )
	);

always @(posedge clk) begin
    if (!rst_n) begin
        rom_address <= 8'b0;
    end else begin
        rom_address <= rom_address + 1;
    end
end

// blink led

reg [31:0] clk_cnt;

always @(posedge clk) begin
    if (!rst_n) begin
        pc <= 1;
        fsr <= 1;
        clk_cnt <= 32'd0;
        leds <= 4'b0000;
    end else begin
        if (clk_cnt == 32'd50_000_000) begin
            clk_cnt <= 32'd0;
            leds <= ~leds;
        end else begin
            clk_cnt <= clk_cnt + 32'd1;
            leds <= leds;
        end
    end    
end


endmodule
