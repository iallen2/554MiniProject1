//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );
	 
	 wire enable;
	 
	 baud_rate_generator _gen_baudy(
									.rst(rst), 
									.clk(clk), 
									.data_bus(databus),
									.iocs(iocs), 
									.iorw(iorw), 
									.ioaddr(ioaddr),
									.enable(enable)
									);
									
	transmit_buffer _transmit_buffy(
									 .clk(clk),
									 .rst(rst),
									 .enable(enable),
									 .iocs(iocs),
									 .iorw(iorw),
									 .ioaddr(ioaddr),
									 .databus(databus),
									 .TxD(txd), 
									 .tbr(tbr)
									 );
				 
	receive_buffer _vampire_receiver(
									 .clk(clk),
									 .rst(rst),
									 .enable(enable),
									 .iocs(iocs),
									 .iorw(iorw),
									 .ioaddr(ioaddr),
									 .databus(databus),
									 .RxD(rxd), 
									 .rda(rda)
									 );
	


endmodule
