//`timescale 1ns/1ps

//================ ALU =================//

module ALU(A,B,ALU_Sel,ALU_Out);

input [15:0] A,B;
input [3:0] ALU_Sel;
output reg [15:0] ALU_Out;

always @(*)
begin
case(ALU_Sel)

4'b0000: ALU_Out = A + B;
4'b0001: ALU_Out = A - B;
4'b0010: ALU_Out = A & B;
4'b0011: ALU_Out = A | B;
4'b0100: ALU_Out = A ^ B;
4'b0101: ALU_Out = A << 1;
4'b0110: ALU_Out = A >> 1;

default: ALU_Out = 16'b0;

endcase
end

endmodule



//================ Register File =================//

module reg_file(clk,rs,rt,rd,write_data,reg_write,data1,data2);

input clk;
input reg_write;

input [3:0] rs,rt,rd;
input [15:0] write_data;

output [15:0] data1,data2;

reg [15:0] registers [0:15];

assign data1 = registers[rs];
assign data2 = registers[rt];

always @(posedge clk)
begin
if(reg_write)
registers[rd] <= write_data;
end

endmodule



//================ Control Unit =================//

module control_unit(opcode,reg_write,alu_src,alu_op);

input [3:0] opcode;

output reg reg_write;
output reg alu_src;
output reg [3:0] alu_op;

always @(*)
begin

case(opcode)

4'b0000:
begin
reg_write = 1;
alu_src = 0;
alu_op = 4'b0000;
end

4'b0001:
begin
reg_write = 1;
alu_src = 0;
alu_op = 4'b0001;
end

4'b0010:
begin
reg_write = 1;
alu_src = 0;
alu_op = 4'b0010;
end

4'b0011:
begin
reg_write = 1;
alu_src = 0;
alu_op = 4'b0011;
end

4'b0100:
begin
reg_write = 1;
alu_src = 1;
alu_op = 4'b0000;
end

default:
begin
reg_write = 0;
alu_src = 0;
alu_op = 4'b0000;
end

endcase

end

endmodule



//================ 16-bit RISC Processor =================//

module risc16(clk,reset);

input clk,reset;

reg [15:0] PC;
reg [15:0] instr_mem [0:255];

wire [15:0] instruction;

wire [3:0] opcode;
wire [3:0] rd,rs,rt;

wire reg_write;
wire alu_src;
wire [3:0] alu_op;

wire [15:0] reg_data1;
wire [15:0] reg_data2;
wire [15:0] alu_in2;
wire [15:0] alu_out;

assign instruction = instr_mem[PC];

assign opcode = instruction[15:12];
assign rd = instruction[11:8];
assign rs = instruction[7:4];
assign rt = instruction[3:0];

control_unit CU(opcode,reg_write,alu_src,alu_op);

reg_file RF(clk,rs,rt,rd,alu_out,reg_write,reg_data1,reg_data2);

assign alu_in2 = (alu_src) ? rt : reg_data2;

ALU ALU1(reg_data1,alu_in2,alu_op,alu_out);

always @(posedge clk or posedge reset)
begin

if(reset)
PC <= 0;

else
PC <= PC + 1;

end

endmodule
