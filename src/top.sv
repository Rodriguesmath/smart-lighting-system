module top #(
  parameter DEBOUNCE_P = 300,
  parameter SWITCH_MODE_MIN_T = 5000,
  parameter AUTO_SHUTDOWN_T = 30000
) (
  // Inputs and Outputs
  input wire clk,               // Clock como entrada
  input wire rst,               // Reset como entrada
  input wire push_button,       // Botão como entrada
  input wire infravermelho,     // Sinal de infravermelho como entrada
  output wire led,              // LED como saída
  output wire saida  
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