
module banco_de_registradores(n_reg,escrita,dado_lido,dado_escrito,clk);
	
	input escrita,clk;
	input [31:0]dado_escrito;
	input [2:0]n_reg;
	output reg[31:0]dado_lido;

	reg[31:0]registrador[0:7];//vetor de palavras de 32 bits
	always @(posedge clk)
	begin
		case(escrita)//controle indica a operação sobre o banco de registradores
			1'b0:dado_lido <= registrador[n_reg];
			1'b1:registrador[n_reg] <= dado_escrito;
		endcase
	end
endmodule

module banco_de_registradores_test_bench();//simula o funcionamento do módulo para diferentes entradas

	reg [2:0]n_reg;
	reg [31:0]dado_escrito;
	reg clk=1;
	reg escrita;
	wire [31:0]dado_lido;

	banco_de_registradores r1(n_reg,escrita,dado_lido,dado_escrito,clk);

	always
		#1 clk=~clk;

	initial begin
	clk=1;

	$dumpfile("test_br.vcd");//gera o arquivo para o gtkwave
	$dumpvars(0,banco_de_registradores_test_bench);

	$monitor("escrita=%b, n_reg=%d , dado_lido=%d , dado_escrito=%d \n",escrita,n_reg,dado_lido,dado_escrito);

	escrita=1; n_reg=3; dado_escrito=1001;//para trocar os inputs basta modificar os valores de entrada
	#20escrita=0; n_reg=3;dado_escrito=0;
	#20escrita=1; n_reg=7;dado_escrito=511;
	#20escrita=0; n_reg=1;dado_escrito=100;
	#20escrita=1; n_reg=0;dado_escrito=999;
	#20escrita=0; n_reg=0;dado_escrito=131;
	#20escrita=1; n_reg=3;dado_escrito=991;
	#20escrita=0; n_reg=3;dado_escrito=1;
	#300 $finish;
	end

endmodule