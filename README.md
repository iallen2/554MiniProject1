# 554MiniProject1

##### Authors: Isabel Allen, Taylor Kemp, Yu-Lin Yang

## Lab 1 Spart
For this project, we built a Special Purpose Asynchronous Receiver/Transmitter (SPART) that consists of a Processor (driver.v) and SPART (spart.v and its constituent files).

#### driver.v
This file consisted of calculating the baud rate and defining the states in which the spart operates.

#### spart.v
This file is the interface for all its constituent modules:
+ baud_rate_generator
  * This creates the enable signals to the transmit and receive buffers
+ transmit_buffer
  * This takes the input data from databus and serializes it to transmit (TxD)
+ receiver_buffer
  * This receives input data from RxD and puts it on the databus.

Note that we omitted the Bus Interface at this primarily consists of combinational logic, and therefore we decided to  implement in the receiver_buffer.


### Record of Experiments

We created a slew of testbenches to simulate input in the transmit and the entire SPART. We did this by creating a task in system verilog, which simulates inputting a character on the actual FPGA board.

Once the waveforms of states and signals of the testbenches appear correct, we tested this on the FPGA board. With Putty open, we tested with multiple characters, repeating characters, double and triple pressing characters.

### Discussion of Problems

We ran into various issues while working on this project. Many of the initial problems involve misunderstanding the project requirements and referencing the wrong documents. For example, we assumed the databus would include two stop bits instead of one and also had a parity bit as per RS232 instructions, but the manual we were reading from was not the intended spec for this project. This caused us to change the databus across the entire SPART from 12 to 10 bits.

Another issue we consistently ran into was creating the counters in the transmit_buffer and receiver_buffer correctly. We were depending on the wrong signals for the counter to increment and reset, thus some characters would be incorrectly transmitted on Putty.

Lastly, we had issues with some baud rates where certain values would break not only the project set to that baud rate, but all settings of the baud rate. For example, for baud rate 9600, using decimal value 323 would cause some incorrect values, but using values 322 and 324 will cause an inability to type in not only baud rate 9600, but all baud rates too. We weren't sure what caused this issue, but we found an optimal baud rate for all the settings which had miniscule errors.
