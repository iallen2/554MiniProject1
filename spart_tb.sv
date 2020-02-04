module spart_tb(); 

reg clk; 
reg rst;
wire iocs;
wire iorw;
wire [1:0]ioaddr;
reg rxd; 
wire [7:0]databus;
wire rda;
wire tbr; 
wire txd; 
reg [1:0] cfg; 

// Instantiate your spart here
spart spart0(   .clk(clk),
                .rst(rst),
                .iocs(iocs),
                .iorw(iorw),
                .rda(rda),
                .tbr(tbr),
                .ioaddr(ioaddr),
                .databus(databus),
                .txd(txd),
                .rxd(rxd)
            );

// Instantiate your driver here
driver driver0( .clk(clk),
                .rst(rst),
                .br_cfg(cfg),
                .iocs(iocs),
                .iorw(iorw),
                .rda(rda),
                .tbr(tbr),
                .ioaddr(ioaddr),
                .databus(databus)
            );


initial begin 

	clk = 1'b0; 
	rst = 1'b1;  
	rxd = 1'b1;
	cfg = 2'b11; //set baudrate as 38400 

	@(posedge clk); 
	rst = 0; //turn off reset. 
	#200; 

	//Send two chars with delay inbetween. 
	put_char(8'h68);
	#200; 
	put_char(8'hAA); 
	#200; 

	//send two chars back to back
	put_char(8'hBB); 
	put_char(8'h81);

	//manually check wave form to make sure TXD is behaving appropiately. && checked Putty. 
end 

always begin 
	#2 clk = ~clk; 
end 

task put_char;
	input [7:0]char;

	rxd = 0; //start bit 
	#328; //time to wait for baud rate 38400
	for(int i = 0; i < 8; i++) begin
		rxd = char[7-i]; 
		#328;
	end
	rxd = 1; //stop bit
	#328; 

endtask


endmodule
