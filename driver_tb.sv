module driver_tb(); 

reg clk; 
reg rst; 
reg [1:0] br_cfg; 
wire iocs; 
wire iorw; 
reg rda; 
reg tbr; 
wire [1:0] ioaddr; 
wire [7:0] databus; 

driver DUT(.clk(clk), 
	   .rst(rst), 
	   .br_cfg(br_cfg), 
	   .iocs(iocs), 
	   .iorw(iorw), 
           .rda(rda), 
	   .tbr(tbr), 
	   .ioaddr(ioaddr), 
	   .databus(databus)); 

initial begin 
	clk = 1'b0; 
	rst = 1'b1; 
	br_cfg = 2'b00; 
	rda = 1'b0; 
	tbr = 1'b1;

	#5; //turn off reset. 
	rst = 1'b0; 

	#50;//wait for baudrate to be set.  
	rda = 1'b1; 
	#10;
	rda = 1'b0;  

	//next clock cycle, signals should be set to read receive buffer 
	//next clock cycle, signals should be set to write transmit buffer
	//back to idle!
	

	#50; //wait
	tbr = 1'b0; // see if driver waits for tbr. 
	rda = 1'b1;
	#10; // signals should be set to read receive buffer
	#10; // should be waiting in receive
	tbr = 1'b1; 
	// now should write transmit buffer 
	
end 

always begin 
	clk = ~clk;
	#5;  
end 

endmodule 
