module transmit_buffer
(
				input clk,
				input rst,
				input enable,
				input iocs,
				input iorw,
				input [1:0]ioaddr,
				inout [7:0]databus,
				output TxD, 
				output tbr);
		
		
		wire new_char;
		reg [3:0]counter;
		wire [3:0]nxt_counter;
		reg transmit_shift_reg_ready;
		reg transfer_buffer_ready;
		wire nxt_transmit_shift_reg_ready;
		wire nxt_transfer_buffer_ready;
		
		
		reg [9:0]transmit_shift_reg;
		reg [7:0]transfer_buffer;
		wire [9:0]nxt_transmit_shift_reg;
		wire [7:0]nxt_transfer_buffer;
		
		assign tbr = transfer_buffer_ready;
		assign TxD = transmit_shift_reg[9];
		assign new_char = (ioaddr == 2'b00 && ~iorw);
		
		assign nxt_transmit_shift_reg = (transmit_shift_reg_ready & ~transfer_buffer_ready) ? {1'b0, {transfer_buffer}, 1'h1}: // character in buffer non in shift reg
												  (new_char & transmit_shift_reg_ready) ? {1'h1, {databus}, 1'b0}:      // shift reg empty and new character (TODO: why shift in this direction?)
												  (enable) ? 										{{transmit_shift_reg[8:0]},  1'b1}: 
																										transmit_shift_reg;  
													
		assign nxt_transfer_buffer = (new_char) ? databus: 
																transfer_buffer;

		assign nxt_transmit_shift_reg_ready = transmit_shift_reg_ready ? (transfer_buffer_ready) : 
																							  counter == 10; 
																							  
		assign nxt_transfer_buffer_ready = transfer_buffer_ready ? !new_char: 
																					  transmit_shift_reg_ready; 
		assign nxt_counter = (~enable)       ? counter : 
									(counter >= 10) ? 4'b0 : 
															counter + 1;  															 
															
							
		always @(posedge clk, posedge rst) begin
			if(rst) begin
				counter <= 4'b0;
			end
			else begin 
				counter <= nxt_counter; 
			end 
		end
		
		always @(posedge clk, posedge rst) begin
			if(rst) begin
				transmit_shift_reg <= 10'hfff;
				transfer_buffer <= 10'hfff;
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
		

endmodule
