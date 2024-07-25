module control(in,f, regdest, alusrc, memtoreg, regwrite, 
	       memread, memwrite, branch, aluop1, aluop2, jal, jump,jr);

input [5:0] in;
input [3:0] f;
output regdest, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop1, aluop2, jal, jump,jr;

wire rformat,lw,sw,beq,jall,j,jump_reg;

assign rformat =~| in;
assign jump_reg = (~|in) & f[3]&(~f[2])&(~f[1])&(~f[0]);

assign j = (~in[5])& (~in[4])&(~in[3])&(~in[2])&in[1]&(~in[0]); // 000010 = 2
assign jall = (~in[5])& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0]; // 000011 = 3
assign lw = in[5]& (~in[4])&(~in[3])&(~in[2])&in[1]&in[0]; // 100011 = 35
assign sw = in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0]; //101011 = 43

assign beq = ~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]); // 000100 = 4

assign regdest = rformat;

assign alusrc = lw|sw;
assign memtoreg = lw;
assign regwrite = rformat|lw|jall;
assign memread = lw;
assign memwrite = sw;
assign branch = beq;
assign aluop1 = rformat;
assign aluop2 = beq;
assign jal = jall;
assign jump = jall|j;
assign jr = jump_reg;


endmodule

