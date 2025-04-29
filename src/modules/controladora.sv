module controladora #(
    parameter DEBOUNCE_P = 300, // Tempo de debounce do botão (em ms)
    parameter SWITCH_MODE_MIN_T = 5000, // Tempo mínimo para mudar o modo (em ms)
    parameter AUTO_SHUTDOWN_T = 30000 // Tempo de desligamento automático (em ms)
) (
    input wire clk, rst,
    input logic inframervelho, push_button,
    output logic led, saida 
);

endmodule;

