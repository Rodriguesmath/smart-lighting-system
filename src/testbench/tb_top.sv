module tb_top;

  // Parameters
  parameter CLK_PERIOD = 10;

  // Signals
  logic clk, rst;
  logic push_button, infravermelho;
  logic led, saida;

  // Instanciação do módulo top
  top uut (
    .clk(clk),
    .rst(rst),
    .push_button(push_button),
    .infravermelho(infravermelho),
    .led(led),
    .saida(saida)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
  end

  // Reset generation
  initial begin
    rst = 0;
    #20;
    rst = 1;
  end

  // Stimulus generation
  initial begin
    push_button = 0;
    infravermelho = 0;

    // Simulação do modo automático
    #30;
    infravermelho = 1; // Movimento detectado
    #50;
    infravermelho = 0; // Sem movimento
    #30000; // Aguarda o tempo de desligamento automático

    // Simulação do modo manual
    #50;
    push_button = 1; // Pressiona o botão
    #5000;
    push_button = 0; // Solta o botão

    // Finaliza a simulação
    #100;
    $finish;
  end

  // Monitoramento
  initial begin
    $monitor("Time: %0t | push_button: %b | infravermelho: %b | led: %b | saida: %b", 
             $time, push_button, infravermelho, led, saida);
  end

endmodule