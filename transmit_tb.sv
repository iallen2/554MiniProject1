module transmit_tb();

reg clk;
				reg rst;
				reg enable;
				reg iocs;
				reg iorw;
				reg [1:0]ioaddr;
				wire [7:0]databus;
				wire TxD; 
				wire tbr;
reg flag; 

transmit_buffer _transmit_buffy(
									 .clk(clk),
									 .rst(rst),
									 .enable(enable),
									 .iocs(iocs),
									 .iorw(iorw),
									 .ioaddr(ioaddr),
									 .databus(databus),
									 .TxD(txd), 
									 .tbr(tbr) );
assign databus = (flag) ? 8'hAA : 8'b0011_1001; 

//iorw = 0 -> reading from processor 
initial begin 
	clk = 1'b0; 
	rst = 1'b1; 
	iocs = 1'b1; 
	iorw = 1'b1;  
	ioaddr = 2'b00;  
	enable = 1'b0; 
	flag = 1'b1; 

	#5; 
	rst = 1'b0; 

	@(posedge clk);
	iorw = 1'b0;  

	@(posedge clk); 
	iorw = 1'b1;


	#2000; 

	flag = 1'b0; 
	@(posedge clk);
	iorw = 1'b0;  

	@(posedge clk); 
	iorw = 1'b1;


end

always begin 
	clk = ~clk; 
	#5; 
end

always begin 
	#80
	enable = 1'b1; 
	@(posedge clk);  
	enable = 1'b0; 
end   

endmodule  
