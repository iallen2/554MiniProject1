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
rxd = 1'b0;  
cfg = 2'b11; 

@(posedge clk); 
rst = 0;
rxd = 1'b1;  
#200; 


@(posedge clk); 
#100;
set_data(0);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);//parity
set_data(1);
set_data(1);
#1000;
set_data(0);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);//parity
set_data(1);
set_data(1);
#1000;
set_data(0);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);//parity
set_data(1);
set_data(1);
#1000;
set_data(0);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);
set_data(0);
set_data(1);//parity
set_data(1);
set_data(1);
#1000;
while(rda != 1) begin 
	set_data(1); 
	set_data(0); 
end 



end 

always begin 
	#2 clk = ~clk; 
end 

task set_data; 
input data; 
begin 
rxd = data; 
#328;
@(posedge clk); 
end 
endtask

endmodule
