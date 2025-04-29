module module_1 #(
    parameter DEBOUNCE_P = 300,
    parameter SWITCH_MODE_MIN_T = 5000
)(
    input wire clk, rst,
    input logic push_button,
    output logic A, B
);

  // Implementação da máquina de estados para o push-button
  // ...

endmodule