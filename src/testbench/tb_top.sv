module tb_top;

  // Parameters
  parameter CLK_PERIOD = 2; // Clock com período de 2 unidades de tempo

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

  // Geração do clock
  always begin
    #1 clk = ~clk; // Clock com período de 2 unidades de tempo
  end

  // Dump de waveform
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(1, tb_top);
  end

  // Geração do reset
  initial begin
    clk = 0;
    rst = 1; // Ativa o reset
    #5 rst = 0; // Libera o reset
  end

  // Estímulos para o sistema
  initial begin
    // Inicializa os sinais
    push_button = 0;
    infravermelho = 0;

    // Teste: Alternância para modo manual
    #10 push_button = 1; // Pressiona o botão por 6 unidades de tempo
    #6 push_button = 0;  // Solta o botão

    // Teste: Controle manual da lâmpada
    #15 push_button = 1; // Pressiona o botão por 1 unidade de tempo
    #1 push_button = 0;  // Solta o botão

    // Teste: Modo automático com movimento
    #20 infravermelho = 1; // Movimento detectado
    #5 infravermelho = 0;  // Sem movimento
    #30; // Aguarda o tempo de desligamento automático

    // Teste: Alternância de volta para modo automático
    #10 push_button = 1; // Pressiona o botão por 6 unidades de tempo
    #6 push_button = 0;  // Solta o botão

    // Finaliza a simulação
    #20 $finish;
  end

  // Monitoramento
  initial begin
    $monitor("Time: %0t | push_button: %b | infravermelho: %b | led: %b | saida: %b", 
             $time, push_button, infravermelho, led, saida);
  end

endmodule