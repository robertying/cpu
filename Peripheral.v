module Peripheral (input sysclk,
                   input reset,
                   input clk,
                   input rd,
                   input wr,
                   input [31:0] addr,
                   input [31:0] wdata,
				   input [7:0] switch,
                   output reg [31:0] rdata,
                   output reg [7:0] led,
                   output reg [11:0] digi,
                   output irqout,
                   input PC_Uart_rxd,
                   output PC_Uart_txd);

reg [31:0] TH, TL;
reg [2:0] TCON;
reg [7:0] tx_data;
wire [7:0] rx_data;
reg count;

// UART_CON
reg tx_enable, rx_enable, tx_flag, rx_flag;
wire tx_status, rx_status;

// UART
UART uart(sysclk, tx_data, rx_data, tx_enable, rx_enable, tx_status, rx_status, PC_Uart_rxd, PC_Uart_txd);

// Interruption signal
assign irqout = TCON[2];

// Timer
always @(negedge reset or posedge clk) begin
	if (~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;
		digi <= 12'b0;
		led <= 8'b0;
		tx_flag <= 0;
		rx_flag <= 0;
		tx_enable <= 0;
		rx_enable <= 1;
		count <= 0;
	end
	else begin
        // Timer enabled
		if (TCON[0]) begin
			if (TL == 32'hffffffff) begin
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
                32'h40000018: begin tx_data <= wdata[7:0]; tx_enable <= 1; end
				default: ;
			endcase
		end

		// Set flags to true when finished sending or receiving
		if (~rx_status)
			count <= 0;
		if (rx_status && ~count) begin
			rx_flag <= 1;
			count <= 1;
		end
		if(tx_status)
			tx_flag <= 1;

		//  Set flags to false when data is read
		if(rd && (addr == 32'h4000001C))
			rx_flag <= 0;
		if(rd && (addr == 32'h4000001C))
			tx_flag <= 0;

		// Only send once
		if (tx_enable == 1) tx_enable <= 0;
	end
end

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
            32'h40000018: rdata <= {24'b0, tx_data};
            32'h4000001C: rdata <= {24'b0, rx_data};
            32'h40000020: rdata <= {27'b0, tx_status, rx_flag, tx_flag, rx_enable, tx_enable};
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

endmodule
