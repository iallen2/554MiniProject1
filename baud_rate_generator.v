module 
baud_rate_generator(
			input rst, 
			input clk, 
			input [7:0]data_bus, 
			input [1:0]ioaddr,
			input iocs, 
			input iorw, 
			output enable);

reg [15:0]final_count_up;
reg [15:0]baud_rate; 
wire [15:0]nxt_baud_rate; 
wire [15:0]nxt_final_count_up; 

assign enable = (final_count_up == baud_rate);

assign nxt_baud_rate = (ioaddr == 2'b10 & !iorw & iocs) ? {{baud_rate[15:8]}, data_bus} : 
		       (ioaddr == 2'b11 & !iorw & iocs) ? {data_bus, {baud_rate[7:0]}} : 
							  baud_rate; 

assign nxt_final_count_up = (final_count_up > baud_rate) ? 16'b0 : 
			    (iocs) ? final_count_up + 1 : final_count_up; 


always @(posedge clk, posedge rst) begin 
	if(rst) begin
		final_count_up <= 16'b0; 
	end 
	else begin 
		final_count_up <= nxt_final_count_up; 
	end 
end

always @(posedge clk, posedge rst) begin 
	if(rst) begin
		baud_rate <= 16'b0; 
	end 
	else begin 
		baud_rate <= nxt_baud_rate; 
	end 
end


endmodule
