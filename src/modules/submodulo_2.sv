module submodulo_2 #(
  parameter DEBOUNCE_P = 300,
  parameter SWITCH_MODE_MIN_T = 5000
) (
  input logic clk, rst, push_button,
  output logic A, B
);

typedef enum logic [2:0] {
  INICIAL,
  DB,
  B_STATE,
  A_STATE,
  TEMP
} state_t;

state_t current_state, next_state;
logic [15:0] Tp;

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    // Reset: volta ao estado inicial e zera o contador
    current_state <= INICIAL;
    Tp <= 0;
    A <= 0;
    B <= 0;
  end else begin
    // Atualiza o estado atual
    current_state <= next_state;

    // Incrementa ou reseta o contador com base no estado
    if (current_state == DB || current_state == B_STATE || current_state == A_STATE) begin
      Tp <= Tp + 1;
    end else begin
      Tp <= 0;
    end

    // Define as saídas com base no estado atual
    case (current_state)
      INICIAL: begin
        A <= 0;
        B <= 0;
      end

      DB: begin
        A <= 0;
        B <= 0;
      end

      B_STATE: begin
        A <= 0;
        B <= (!push_button) ? 1 : 0; // Ativa B somente quando o botão é solto
      end

      A_STATE: begin
        A <= (!push_button) ? 1 : 0; // Ativa A somente quando o botão é solto
        B <= 0;
      end

      TEMP: begin
        A <= A; // Mantém os valores de A e B
        B <= B;
      end

      default: begin
        A <= 0;
        B <= 0;
      end
    endcase
  end
end

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    next_state <= INICIAL; // Reset: próximo estado é INICIAL
  end else begin
    // Define o próximo estado com base no estado atual e nas condições
    case (current_state)
      INICIAL: begin
        if (push_button) next_state <= DB;
        else next_state <= INICIAL;
      end

      DB: begin
        if (Tp < DEBOUNCE_P) next_state <= DB;
        else if (!push_button) next_state <= INICIAL;
        else if (Tp >= DEBOUNCE_P) next_state <= B_STATE;
      end

      B_STATE: begin
        if (Tp < SWITCH_MODE_MIN_T) next_state <= B_STATE;
        else if (!push_button) next_state <= TEMP;
        else if (Tp >= SWITCH_MODE_MIN_T) next_state <= A_STATE;
      end

      A_STATE: begin
        if (Tp < SWITCH_MODE_MIN_T) next_state <= A_STATE;
        else if (!push_button) next_state <= TEMP;
      end

      TEMP: begin
        next_state <= INICIAL;
      end

      default: begin
        next_state <= INICIAL;
      end
    endcase
  end
end

endmodule