module controladora #(
    parameter DEBOUNCE_P = 300,          // Tempo de debounce do botão (em ms)
    parameter SWITCH_MODE_MIN_T = 5000, // Tempo mínimo para mudar o modo (em ms)
    parameter AUTO_SHUTDOWN_T = 30000   // Tempo de desligamento automático (em ms)
) (
    input wire clk, rst,                 // Clock e reset
    input logic infravermelho,           // Sinal de infravermelho
    input logic push_button,             // Botão de controle
    output logic led, saida              // Saídas do sistema
);

  // Sinais internos para comunicação entre os submódulos
  logic A, B, C;                         // Saídas dos submódulos
  logic a, b, c, d;                      // Entradas da máquina principal

  // Instância do módulo 1 (controle do botão)
  module_1 #(
    .DEBOUNCE_P(DEBOUNCE_P),
    .SWITCH_MODE_MIN_T(SWITCH_MODE_MIN_T)
  ) u_module_1 (
    .clk(clk),
    .rst(rst),
    .push_button(push_button),
    .A(A),
    .B(B)
  );

  // Instância do módulo 2 (controle do infravermelho)
  module_2 #(
    .AUTO_SHUTDOWN_T(AUTO_SHUTDOWN_T)
  ) u_module_2 (
    .clk(clk),
    .rst(rst),
    .infravermelho(infravermelho),
    .C(C)
  );

  // Conexão dos sinais para a máquina principal
  assign a = A;                          // Sinal A do módulo 1
  assign b = B;                          // Sinal B do módulo 1
  assign c = C;                          // Sinal C do módulo 2
  assign d = infravermelho;              // Sinal direto do infravermelho

  // Instância da máquina principal
  maquina_principal u_maquina_principal (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .led(led),
    .saida(saida)
  );

endmodule

