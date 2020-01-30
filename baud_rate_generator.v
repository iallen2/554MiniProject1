module 
baud_rate_generator(
			input rst, 
			input clk, 
			input [7:0]data_bus, 
			input [1:0]ioaddr,
			output enable);

reg [15:0]final_count_up;
reg [15:0]baud_rate; 

assign enable = (final_count_up == baud_rate);

always @(posedge clk, posedge rst) begin
	if(rst) begin
		final_count_up = 0;
	end 
	else if(final_count_up > baud_rate) begin
		final_count_up = 0;
	end
	else begin
		final_count_up = final_count_up + 1;
	end
end

always @(posedge clk, posedge rst) begin 
	if(rst) begin
		baud_rate = 16'b0; 
	end 
	else if(ioaddr == 2'b10) begin // DB LOW
		baud_rate = {{baud_rate[15:8]}, data_bus};
	end 
	else if(ioaddr == 2'b11) begin // DB HIGH
		baud_rate = {data_bus, {baud_rate[7:0]}};
	end
end


endmodule
