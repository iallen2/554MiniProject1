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

#15
rst = 1'b0; 

//should set baudrate
#50; 
rda = 1'b1; 

$stop; 

end 

always begin 
	clk = ~clk;
	#5;  
end 

endmodule 
