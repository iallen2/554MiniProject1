
module receive_tb(); 


	reg clk; 
				reg rst;
				reg enable;
				reg iocs;
				reg iorw;
				reg [1:0]ioaddr;
				reg RxD; 
				wire [7:0]databus;
				wire rda;

	receive_buffer _vampire_receiver(
									 .clk(clk),
									 .rst(rst),
									 .enable(enable),
									 .iocs(iocs),
									 .iorw(iorw),
									 .ioaddr(ioaddr),
									 .databus(databus),
									 .RxD(RxD), 
									 .rda(rda)
									 );



initial begin 

	clk = 1'b0; 
	rst = 1'b1; 
	iocs = 1'b1; 
	iorw = 1'b0; 
	ioaddr = 2'b00; 
	RxD = 1'b1; 
	enable = 1'b0; 

	@(posedge clk); 
	rst = 0; 

	//Send two chars with delay inbetween. 
	put_char(8'h68);
	#200; 
	put_char(8'hAA); 
	#200; 

	//send two chars back to back
	put_char(8'hBB); 
	put_char(8'h81);

end 

always begin 
	#2 clk = ~clk; 
end 

task put_char;
	input [7:0]char;

	RxD = 0; //start bit 
	enable = 1'b1; 
	@(posedge clk); 
	enable = 1'b0; 
	#324; //time to wait for baud rate 38400
	for(int i = 0; i < 8; i++) begin
		RxD = char[7-i];
		enable = 1'b1; 
		@(posedge clk);  
		enable = 1'b0;		
		#324;
	end
	RxD = 1; //stop bit
	enable = 1'b1; 
	@(posedge clk);  
	enable = 1'b0;
	#324; 
endtask

endmodule
