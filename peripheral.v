`timescale 1ns/1ps

module peripheral (input reset,
                   input clk,
                   input rd,
                   input wr,
                   input [31:0] addr,
                   input [31:0] wdata,
                   output [31:0] rdata,
                   output [7:0]  led,
                   output [7:0] switch,
                   output reg [11:0] digi,
                   output irqout,
                   input PC_Uart_rxd,
                   output PC_Uart_txd);

// Interrupt
reg [31:0] TH, TL;
reg [2:0] TCON;
assign irqout = TCON[2];

// Timer
always @(negedge reset or posedge clk) begin
	if (~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;	
	end
	else begin
        // Timer enabled
		if (TCON[0]) begin
			if (TL==32'hffffffff) begin
				TL <= TH;
                // Interruption enabled
				if (TCON[1]) TCON[2] <= 1'b1;
			end
			else TL <= TL + 1;
		end
		
        // Write requires one cycle to be done; use Timer's clk
		if (wr) begin
			case (addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
                32'h40000018: begin UART_TXD <= wdata[7:0]; tx_enable <= 1'b1; end
				default: ;
			endcase
		end
	end
end

// UART
reg [31:0] UART_TXD, UART_RXD;
reg tx_enable, rx_enable, tx_flag, rx_flag, tx_status;
UART _UART(clk, UART_TXD, UART_RXD, tx_enable, rx_enable, tx_flag, rx_flag, tx_status, PC_Uart_rxd, PC_Uart_txd);

// Read can be straight
always @(*) begin
	if (rd) begin
		case (addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0, TCON};				
			32'h4000000C: rdata <= {24'b0, led};			
			32'h40000010: rdata <= {24'b0, switch};
			32'h40000014: rdata <= {20'b0, digi};
            32'h40000018: begin rdata <= {24'b0, UART_TXD}; tx_flag <= 1'b0; end
            32'h4000001C: begin rdata <= {24'b0, UART_RXD}; rx_flag <= 1'b0; end
            32'h40000020: rdata <= {27'b0, tx_status, rx_flag, tx_flag, rx_enable, tx_enable};
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

endmodule
