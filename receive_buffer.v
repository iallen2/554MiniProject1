module receive_buffer
(
				input clk,
				input rst,
				input enable,
				input iocs,
				input iorw,
				input [1:0]ioaddr,
				input RxD, 
				inout [7:0]databus,
				output rda);
		
		
		

		wire done; 
		reg [3:0]counter;
		wire [3:0]nxt_counter;
		reg receiving_character;
		wire nxt_receiving_character;
		reg [11:0]receive_shift_reg;
		wire [11:0]nxt_receive_shift_reg;
		reg[7:0] receive_buffer; 
		wire[7:0] nxt_receive_buffer; 
		reg char_in_buffer;
		wire nxt_char_in_buffer;

		assign done = counter >= 12;	

		

		assign nxt_counter = (~receiving_character & enable)  ? 4'h0: 
				     (enable)? counter + 1: 
					       counter;

		
		assign nxt_receiving_character = (receiving_character) ? counter < 12 : ~RxD;
		

		assign nxt_receive_shift_reg = (receiving_character & enable) ? {receive_shift_reg[10:0], RxD}
									      : receive_shift_reg;

		assign nxt_receive_buffer = (done) ? receive_shift_reg[10:3]: receive_buffer;
				
	   

		assign nxt_char_in_buffer = (char_in_buffer) ? !(iorw & ioaddr == 2'b00) : done; 
		assign rda = char_in_buffer; 
		

		assign databus = (iorw == 1'b1 && ioaddr == 2'b00) ? receive_shift_reg : 8'hzz; 
		

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
				receive_shift_reg <= 12'hfff;
				receiving_character <= 1'b0; 
				receive_shift_reg <= 12'h000;
			   	receive_buffer <= 8'h00;
				char_in_buffer <= 1'b0; 
			end
			else begin
				receive_shift_reg <= nxt_receive_shift_reg;
				receiving_character <= nxt_receiving_character; 
				receive_shift_reg <= nxt_receive_shift_reg; 
				receive_buffer <= nxt_receive_buffer; 
				char_in_buffer <= nxt_char_in_buffer; 
			end
		end
	
endmodule
