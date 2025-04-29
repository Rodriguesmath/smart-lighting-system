module top #(
  parameter DEBOUNCE_P = 300,
  parameter SWITCH_MODE_MIN_T = 5000,
  parameter AUTO_SHUTDOWN_T = 30000
) (
  // Inputs and Outputs
  logic clk, rst,
  logic push_button, infravermelho,
  logic led, saida
);
  // Instanciação do módulo controladora
  controladora #(
    .DEBOUNCE_P(DEBOUNCE_P),
    .SWITCH_MODE_MIN_T(SWITCH_MODE_MIN_T),
    .AUTO_SHUTDOWN_T(AUTO_SHUTDOWN_T)
  ) u_controladora (
    .clk(clk),
    .rst(rst),
    .push_button(push_button),
    .infravermelho(infravermelho),
    .led(led),
    .saida(saida)
  );

endmodule