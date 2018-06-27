module multiplicador(var1, var2, wireout);

	input [31:0] var1, var2;
	reg [31:0]armazem_somas;
	wire [31:0] var1_ext;
	output wire [31:0] wireout;
	integer i;
	reg [31:0]out;

	assign var1_ext = var1;//operação usará um fio com os sinais de var 1 para alimentar o loop


	always@(*)
		begin
		armazem_somas = var1_ext & {(32){var2[0]}};
		out=armazem_somas;
		for(i=1; i<32; i=i+1)//preenche o vetor de armazenamento. a cada loop, é shiftado 1 bit
			begin
			armazem_somas=(var1_ext<<i) & {32{var2[i]}};//se o bit i for 1 serão 32 1s, se for 0 serão 32 0s
			out=out+armazem_somas;
			end
		end

	assign wireout = out;
endmodule

module divisor(var1, var2, wireout);
	
	input [31:0] var1, var2;
	reg[31:0] out=32'b0;
	output wire[31:0] wireout;
	wire[31:0]var1_ext;
	reg [31:0]dividendo_atual=32'b0;


	assign var1_ext = var1;


	integer i;

	always @(*)//inicio do algoritmo
	begin
	out=32'b0;
	dividendo_atual=32'b0;
		for(i=31;i>=0;i=i-1)
			begin
			dividendo_atual=(dividendo_atual<<1)+(var1_ext[i]);
			if((dividendo_atual)<(var2)) //se o acumulado for menor,preenche com 0
				begin
				out[0]=0;
				out=out<<1;//o output será preenchido de forma que os bits mais significativos serão preenchidos primeiro	
				end
			else 
				begin//se o acumulado dor maior ou igual ao divisor, preenche com 1 e subtrai o divisor do dividendo atual, semelhante à uma divisão normal
				out[0]=1;
				out=out<<1;//output será preenchida bit a bit, sempre preenchendo o bit menos significativo e shiftando 1
				dividendo_atual=dividendo_atual-var2;
				end
			end		
	end
	assign wireout=out>>1;
endmodule

module alu(n1,n2,op,res1);
	input [31:0]n1;
	input [31:0]n2;
	input [1:0]op;
	reg[31:0]res;
	wire [31:0]wireout,wireout2;
	output [31:0]res1;

 
	multiplicador m1(n1,n2,wireout);//chama os módulos de div e mult
	divisor d1(n1,n2,wireout2);


	always @(*)
	begin
		case(op)//controle encaminha a operação correta sobre as entradas
		 2'b00:res<=n1+n2;
		 2'b01:res<=n1-n2;
		 2'b10:res<=wireout;
		 2'b11:res<=wireout2;
		 endcase
	end

	assign res1=res;
endmodule


module alu_test_bench();//simula o funcionamento do módulo para diferentes entradas

	reg [31:0]n1,n2;
	wire [31:0]res1;
	reg clk=1;
	reg [1:0]op;

	alu a1(n1,n2,op,res1);

	initial begin

	$dumpfile("test_alu.vcd");//gera o arquivo para o gtkwave
	$dumpvars(0,alu_test_bench);

	$monitor("n1=%d , n2=%d , op=%d , res=%b \n",n1,n2,op,res1);

	n1= 17 ;n2= 21 ;op= 0 ;//para trocar os inputs basta modificar os valores de entrada
	#20n1= 55 ;n2= 40 ;op= 1;
	#20n1= 7;n2=12 ;op= 2;
	#20n1=14 ;n2= 3  ;op= 3;
	#20n1= 9999;n2= 1;op= 0;
	#20n1= 1 ;n2= 2;op= 1;
	#20n1=77 ;n2= 11 ;op= 2;
	#20n1= 999;n2=9 ;op= 3;
	end
	always @(*)
		#50 clk=!clk;

endmodule

