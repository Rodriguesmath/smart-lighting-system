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
  typedef enum logic [1:0] {
    INICIAL,
    DB,
    B_STATE,
    A_STATE
  } state_t;

  state_t current_state, next_state;
  logic [15:0] Tp; 

    // Máquina de estados sequencial (atualização do estado atual)
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      current_state <= INICIAL;         // Reset: volta ao estado inicial
      Tp <= 0;                          // Zera o contador
    end else begin
      current_state <= next_state;      // Atualiza o estado atual
      if (current_state == DB || current_state == B_STATE || current_state == A_STATE) begin
        Tp <= Tp + 1;                   // Incrementa o contador nos estados que usam Tp
      end else begin
        Tp <= 0;                        // Zera o contador nos outros estados
      end
    end
  end

  // Máquina de estados combinacional (lógica de transição de estados)
  always_comb begin
    // Valores padrão
    next_state = current_state;
    A = 0;
    B = 0;

    case (current_state)
      INICIAL: begin
        if (push_button) begin
          next_state = DB;              // Transição para o estado de debounce
        end
      end

      DB: begin
        if (Tp < DEBOUNCE_P) begin
          next_state = DB;              // Permanece no estado DB enquanto Tp < DEBOUNCE_P
        end else begin
          next_state = B_STATE;         // Transição para o estado B
        end
      end

      B_STATE: begin
        if (Tp < SWITCH_MODE_MIN_T) begin
          next_state = B_STATE;         // Permanece no estado B enquanto Tp < SWITCH_MODE_MIN_T
        end else begin
          next_state = A_STATE;         // Transição para o estado A
        end
      end

      A_STATE: begin
        if (!push_button) begin
          next_state = INICIAL;         // Volta ao estado inicial quando o botão é solto
          A = 1;                        // Define a saída A como 1
        end else begin
          next_state = A_STATE;         // Permanece no estado A enquanto o botão estiver pressionado
        end
      end

      default: begin
        next_state = INICIAL;           // Estado padrão (segurança)
      end
    endcase
  end

endmodule