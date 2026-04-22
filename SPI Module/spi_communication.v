//=============================================================================
// SPI Communication Module 
// -----------------------------------------------------------------------------
// Top-level module containing SPI Master and SPI Slave submodules.

module SPI_Communication (
    
);

    wire        mosi_w;
    wire        miso_w;
    wire        sclk_w;
    wire [7:0]  ss_w;
    wire        cs_w;     

    SPI_Master u_master (
        .REFCLK (),
        .INPUT  (),
        .CNTL   (),
        .OUTPUT (),
        .READY  (),
        .MOSI   (mosi_w),
        .MISO   (miso_w),
        .SCLK   (sclk_w),
        .SS     (ss_w)
    );

    SPI_Slave u_slave (
        .INPUT  (),
        .LOAD   (),
        .OUTPUT (),
        .READY  (),
        .MOSI   (mosi_w),
        .MISO   (miso_w),
        .SCLK   (sclk_w),
        .CS     (cs_w)
    );

endmodule


//=============================================================================
// SPI Master 
// Posedge-triggered on REFCLK. Drives SCLK, MOSI, and SS.
// CNTL codes:
//   2'b00 : No operation
//   2'b01 : Load INPUT as transmit data        (only when READY)
//   2'b10 : Load INPUT as slave-select index   (only when READY)
//           - SS is active-LOW; e.g. INPUT=3  -> SS = 8'b1111_0111
//           - INPUT >= 8                       -> SS = 8'b1111_1111 (none)
//   2'b11 : Begin full-duplex transmission     (only when READY)
//           - READY drops during transmission
//           - READY rises again when 8 bits done AND CNTL != 2'b11
//=============================================================================
module SPI_Master (
    input  wire        REFCLK,
    input  wire [7:0]  INPUT,
    input  wire [1:0]  CNTL,
    output reg  [7:0]  OUTPUT,
    output reg         READY,
    output reg         MOSI,
    input  wire        MISO,
    output reg         SCLK,
    output reg  [7:0]  SS
);

    // CNTL 
    localparam CNTL_NOP   = 2'b00;
    localparam CNTL_LOAD  = 2'b01;
    localparam CNTL_SEL   = 2'b10;
    localparam CNTL_START = 2'b11;

    // Internal state
    reg [7:0] tx_shift;      // Data being shifted out on MOSI
    reg [7:0] rx_shift;      // Data being shifted in from MISO
    reg [3:0] bit_count;     // Number of bits transferred in current frame
    reg       busy;          // High while a transmission is in progress

    initial begin
        OUTPUT    = 8'h00;
        READY     = 1'b1;
        MOSI      = 1'b0;
        SCLK      = 1'b0;
        SS        = 8'hFF;   
        tx_shift  = 8'h00;
        rx_shift  = 8'h00;
        bit_count = 4'd0;
        busy      = 1'b0;
    end

    always @(posedge REFCLK) begin
        case (CNTL)
            CNTL_NOP: begin
                
            end

            CNTL_LOAD: begin
                
            end

            CNTL_SEL: begin
                
            end

            CNTL_START: begin
                
            end
        endcase
    end

endmodule


//=============================================================================
// SPI Slave 
// Driven by SCLK from the master while CS is asserted.
// LOAD: when high and READY, load INPUT as the next byte to transmit.
// READY: high whenever the slave is not currently in a transmission.
//=============================================================================
module SPI_Slave (
    input  wire [7:0]  INPUT,
    input  wire        LOAD,
    output reg  [7:0]  OUTPUT,
    output reg         READY,
    input  wire        MOSI,
    output reg         MISO,
    input  wire        SCLK,
    input  wire        CS
);

    reg [7:0] tx_shift;
    reg [7:0] rx_shift;
    reg [3:0] bit_count;


    initial begin
        OUTPUT    = 8'h00;
        READY     = 1'b1;
        MISO      = 1'b0;
        tx_shift  = 8'h00;
        rx_shift  = 8'h00;
        bit_count = 4'd0;
    end

    
    always @(posedge SCLK) begin
        
    end

endmodule
