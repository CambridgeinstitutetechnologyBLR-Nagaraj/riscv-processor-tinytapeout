`default_nettype none

module tt_um_riscv_processor (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    // Reset conversion
    wire rst = ~rst_n;

    // Processor memory interface
    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [31:0] dmem_rdata;
    wire dmem_we;

    // Debug signals
    wire [31:0] pc_out;
    wire [31:0] wb_data_out;
    wire wb_we_out;

    // Instruction ROM
    reg [31:0] instruction;

    always @(*) begin
        case (imem_addr)
            32'd0:  instruction = 32'h00500093;
            32'd4:  instruction = 32'h00700113;
            32'd8:  instruction = 32'h002081B3;
            32'd12: instruction = 32'h06302023;
            32'd16: instruction = 32'h06002203;
            default: instruction = 32'h00000013;
        endcase
    end

    assign imem_rdata = instruction;

    // Internal data RAM: 256 words
    reg [31:0] data_mem [0:255];

    // Data memory read
    assign dmem_rdata = data_mem[dmem_addr[9:2]];

    // Data memory write
    always @(posedge clk) begin
        if (dmem_we && !rst)
            data_mem[dmem_addr[9:2]] <= dmem_wdata;
    end

    // RISC-V processor
    rv32i_top processor (
        .clk(clk),
        .rst(rst),

        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),

        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_rdata(dmem_rdata),
        .dmem_we(dmem_we),

        .pc_out(pc_out),
        .wb_data_out(wb_data_out),
        .wb_we_out(wb_we_out)
    );

    // GPIO debug outputs
    assign uo_out  = pc_out[9:2];
    assign uio_out = wb_data_out[7:0];
    assign uio_oe  = 8'hFF;

    wire _unused = &{ena, ui_in, uio_in, wb_we_out, 1'b0};

endmodule

`default_nettype wire
