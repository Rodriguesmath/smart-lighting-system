`include "tb_utils.sv"

module tb_top;

  // Signals
  logic CLOCK, RESET;
  logic PUSH_BUTTON, INFRAVERMELHO;
  logic led, saida;

  // Instanciação do módulo top
  top uut (
    .clk(CLOCK),
    .rst(RESET),
    .push_button(PUSH_BUTTON),
    .infravermelho(INFRAVERMELHO),
    .led(led),
    .saida(saida)
  );

  always #1 CLOCK = ~CLOCK; // 1 KHz Clock

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(1, tb_top);
  end

  // Chamada das tasks para teste
  initial begin
    CLOCK = 0;
    RESET = 0;
    PUSH_BUTTON = 0;
    INFRAVERMELHO = 0;

    tb_utils::reset_system(RESET);
    tb_utils::pausa(10000);
    tb_utils::modo_automatico_com_movimento(INFRAVERMELHO);
    tb_utils::modo_automatico_com_movimento(INFRAVERMELHO);

  $finish;
  end

endmodule