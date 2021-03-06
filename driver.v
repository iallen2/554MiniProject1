//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    output iocs,
    output iorw,
    input rda,
    input tbr,
    output [1:0] ioaddr,
    inout [7:0] databus
    );

	reg [2:0]state;
	reg [7:0]databus_reg; 
	reg [2:0]nxt_state;
	wire [15:0]db;
	wire [7:0]db_high;
	wire [7:0]db_low;

	
	assign iocs = 1'b1;
	
	assign db = (br_cfg == 2'b00) ? 680: // baud rate: 4800
					(br_cfg == 2'b01) ? 339: // baud rate: 9600
					(br_cfg == 2'b10) ? 170: // baud rate: 19200
					                     85; // baud rate: 38400 
	
	assign db_high = db[15:8];
	assign db_low = db[7:0];
	
	assign iorw = (state == 3'b000 || state == 3'b010);
	
	assign ioaddr  =   (state == 3'b001) ? 2'b11: // db high
							 (state == 3'b100) ? 2'b10: // db low
							 (state == 3'b010) ? 2'b01: // status register
						      						2'b00; // transmit buffer/receive buffer
														
	assign databus = (state == 3'b001) ? db_high: // db high
		         (state == 3'b100) ? db_low: // db low
			 (state == 3'b011) ? databus_reg: //transmit
													 8'hzz; 
	
	
	always @(posedge rst or posedge clk) begin
		if(rst) begin
			state <= 3'b001;
		end
		else begin
			state <= nxt_state;
		end
	end
	
	always @(posedge rst or posedge clk) begin
		if(rst) begin
			databus_reg <= 8'h00;
		end
		else if(state == 3'b000)  begin //receive
			databus_reg <= databus; 
		end
		else begin 
			databus_reg <= 8'h00;  
		end 
	end
	
	
	always @ (*) begin
		case(state)
			3'b000: begin // receive
				if(tbr) begin
					nxt_state = 3'b011; //goto transmit
				end
			end
			3'b001: begin // db high
					nxt_state = 3'b100; //goto dblow
				
			end
			3'b010: begin // idle
					if(rda) begin
						nxt_state = 3'b000; //goto receive
					end
			end
			3'b011: begin // transmit
				nxt_state = 3'b010; // goto idle
			end
			default: begin // particle strike(db low)
				nxt_state = 3'b010; //goto idle
			end
		endcase
	end
	


endmodule