`timescale 1ns/1ps

module risc16_tb;

reg clk;
reg reset;

risc16 uut(
.clk(clk),
.reset(reset)
);


// Clock generation

initial
begin
clk = 0;
forever #5 clk = ~clk;
end


// Reset

initial
begin
reset = 1;
#10
reset = 0;
end


// Program instructions

initial
begin

uut.instr_mem[0] = 16'b0100_0001_0000_0101; // ADDI R1,R0,5
uut.instr_mem[1] = 16'b0100_0010_0000_0011; // ADDI R2,R0,3
uut.instr_mem[2] = 16'b0000_0011_0001_0010; // ADD R3,R1,R2
uut.instr_mem[3] = 16'b0001_0100_0001_0010; // SUB R4,R1,R2
uut.instr_mem[4] = 16'b0010_0101_0001_0010; // AND R5,R1,R2
uut.instr_mem[5] = 16'b0011_0110_0001_0010; // OR R6,R1,R2

end


// Dump waveform

initial
begin
$dumpfile("risc16.vcd");
$dumpvars(0,risc16_tb);
#200 $finish;
end

endmodule
