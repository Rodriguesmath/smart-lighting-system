module controladora #(
  parameter DEBOUNCE_P = 300, // Tempo de debounce do botão (em ms)
  parameter SWITCH_MODE_MIN_T = 5000, // Tempo mínimo para mudar o modo (em ms)
  parameter AUTO_SHUTDOWN_T = 30000 // Tempo de desligamento automático (em ms)
) (
  input wire clk, rst, // Clock e reset
  input logic infravermelho, // Sinal de infravermelho
  input logic push_button, // Botão de controle
  output logic led, saida // Saídas do sistema
);

  // Sinais internos para comunicação entre os submódulos
  logic A, B, C; // Saídas dos submódulos
  logic enable; // Sinal de habilitação

  // Instância do submódulo 1 (máquina principal)
  submodulo_1 u_submodulo_1 (
    .clk(clk),
    .rst(rst),
    .a(A),
    .b(B),
    .c(C),
    .d(infravermelho),
    .enable(enable), 
    .led(led),
    .saida(saida)
  );

  // Instância do submodulo 2 (controle do botão)
  submodulo_2 #(
    .DEBOUNCE_P(DEBOUNCE_P),
    .SWITCH_MODE_MIN_T(SWITCH_MODE_MIN_T)
  ) u_submodulo_2 (
    .clk(clk),
    .rst(rst),
    .push_button(push_button),
    .A(A),
    .B(B)
  );

  // Instância do submódulo 3 (controle do infravermelho)
  submodulo_3 #(
  .AUTO_SHUTDOWN_T(AUTO_SHUTDOWN_T)
  ) u_submodulo_3 (
    .clk(clk),
    .rst(rst),
    .infravermelho(infravermelho),
    .enable(enable), // Adiciona enable sempre ativo, ajuste conforme necessário
    .C(C)
  );

endmodule