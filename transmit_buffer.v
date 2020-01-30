module transmit_buffer
(
				input clk,
				input rst,
				input enable,
				input iocs,
				input iorw,
				input [1:0]ioaddr,
				input [7:0]databus,
				output TxD, 
				output tbr);
		
		
		wire new_char;
		reg [3:0]counter;
		wire [3:0]nxt_counter;
		reg transmit_shift_reg_ready;
		reg transfer_buffer_ready;
		wire nxt_transmit_shift_reg_ready;
		wire nxt_transfer_buffer_ready;
		
		
		reg [11:0]transmit_shift_reg;
		reg [7:0]transfer_buffer;
		wire [11:0]nxt_transmit_shift_reg;
		wire [7:0]nxt_transfer_buffer;
		
		assign tbr = transfer_buffer_ready | transmit_shift_reg_ready;
		assign TxD = transmit_shift_reg[11];
		assign new_char = (ioaddr == 2'b00 && ~iorw);
		
		assign nxt_transmit_shift_reg = (transmit_shift_reg_ready & ~transfer_buffer_ready) ? {2'h3, ^transfer_buffer, {transfer_buffer}, 0}: // character in buffer non in shift reg
													(new_char & transmit_shift_reg_ready) ? {2'h3, ^databus, {databus}, 0}:      // shift reg empty and new character
													(enable) ? {{transmit_shift_reg[10:0]},  1}: transmit_shift_reg; 
													
		assign nxt_transfer_buffer = (transmit_shift_reg_ready) ? 12'hfff:
												(new_char & transfer_buffer_ready) ? databus:
																								 12'hfff;
		assign nxt_transmit_shift_reg_ready = transmit_shift_reg_ready ? ! (new_char | !transfer_buffer_ready) : 
																							  counter == 12; 
																							  
		assign nxt_transfer_buffer_ready = transfer_buffer_ready ? ! (new_char & !transmit_shift_reg_ready) : 
																						 transmit_shift_reg_ready; 
																						 
															
							
		always @(posedge clk, posedge rst) begin
			if(rst) begin
				counter <= 4'b0;
			end
			else if(enable) begin
				if(counter >= 12) begin
					counter <=4'b0;
				end else begin
					counter <= counter +1;
				end
			end
		end
		
		always @(posedge clk, posedge rst) begin
			if(rst) begin
				transmit_shift_reg <= 12'hfff;
				transfer_buffer <= 12'hfff;
				transmit_shift_reg_ready <= 1'b1; 
				transfer_buffer_ready <= 1'b1; 
			end
			else begin
				transmit_shift_reg <= nxt_transmit_shift_reg;
				transfer_buffer <= nxt_transfer_buffer;
				transmit_shift_reg_ready <= nxt_transmit_shift_reg_ready; 
				transfer_buffer_ready <= nxt_transfer_buffer_ready; 
			end
		end
		
/*		
		reg shift_reg_ready;
		reg tbr_reg;
		wire new_char; 
		wire nxt_tbr_reg; 
		wire nxt_shift_reg_ready; 
		reg [2:0]final_counter;
		reg [7:0]transfer_buffer;
		wire [7:0] nxt_transmit_shift_reg; 
		reg [7:0]transmit_shift_reg; 
		assign TxD = transmit_shift_reg[7];
		
		assign nxt_transmit_shift_reg = (ioaddr == 2'b00 && ~iorw) ? databus:
												  (enable) 						  ? transmit_shift_reg << 1:
												  (shift_register_ready) 	  ? transfer_buffer:
																						 transmit_shift_reg;
		assign tbr = (tbr_reg);
		
		assign nxt_shift_reg_ready = shift_reg_ready ? !tbr: 
											 (final_counter == 3'b7);
										
		assign nxt_tbr_reg = 
		
		
		always @(posedge clk or posedge rst) begin
			if(rst) begin
				final_counter = 0;
			else if(enable) begin
				final_counter = final_counter + 1;
			end 
			else begin
				final_counter = final_counter;
			end
		end
		
		always @(posedge clk or posedge rst) begin 
				if(rst) begin
					transmit_shift_reg <= 8'b0;
				end
				else begin 
					transmit_shift_reg <= nxt_transmit_shift_reg;
				end	

		end 
		
		
		
*/
endmodule
