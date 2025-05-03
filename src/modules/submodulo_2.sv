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
logic reg_a, reg_b; // Registros intermediários

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    current_state <= INICIAL;
    Tp <= 0; // Resetar Tp no reset
  end else begin
    current_state <= next_state;

    // Lógica de contagem ajustada
    case (current_state)
      DB, B_STATE, A_STATE: begin
        if (next_state == current_state) begin
          Tp <= Tp + 1; // Incrementar apenas se permanecer no mesmo estado
        end else begin
          Tp <= 0; // Resetar Tp ao sair do estado
        end
      end

      default: begin
        Tp <= 0; // Resetar Tp em outros estados
      end
    endcase
  end
end


// Lógica de transição de estados
always_comb begin
  case (current_state)
    INICIAL: begin
      if (push_button) next_state = DB;
      else next_state = INICIAL;
    end

    DB: begin
      if (Tp < DEBOUNCE_P) next_state = DB;
      else if (!push_button) next_state = INICIAL;
      else next_state = B_STATE;
    end

    B_STATE: begin
      if (!push_button) next_state = TEMP;
      else if (Tp >= SWITCH_MODE_MIN_T) next_state = A_STATE;
      else next_state = B_STATE;
    end

    A_STATE: begin
      if (!push_button) next_state = TEMP;
      else next_state = A_STATE;
    end

    TEMP: begin
      next_state = INICIAL;
    end

    default: begin
      next_state = INICIAL;
    end
  endcase
end

// Lógica para atualizar os registros intermediários
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    reg_a <= 0;
    reg_b <= 0;
  end else begin
    case (next_state)
      INICIAL: begin
        if (current_state == TEMP) begin
          reg_a <= reg_a;
          reg_b <= reg_b;
        end else begin
          reg_a <= 0;
          reg_b <= 0;
        end
      end

      TEMP: begin
        if (current_state == B_STATE) begin
          reg_b <= 1;
          reg_a <= 0;
        end else if (current_state == A_STATE) begin
          reg_a <= 1;
          reg_b <= 0;
        end else begin
          reg_a <= reg_a;
          reg_b <= reg_b;
        end
      end

      default: begin
        reg_a <= 0;
        reg_b <= 0;
      end
    endcase
  end
end

// Lógica para as saídas
always_comb begin
  if (rst) begin
    A = 0;
    B = 0;
  end else begin
    case (next_state)
      INICIAL: begin
        if (current_state == TEMP) begin
          A = reg_a;
          B = reg_b;
        end else begin
          A = 0;
          B = 0;
        end
      end

      TEMP: begin
        if (current_state == B_STATE) begin
          B = 1;
          A = 0;
        end else if (current_state == A_STATE) begin
          A = 1;
          B = 0;
        end
      end

      default: begin
        A = 0;
        B = 0;
      end
    endcase
  end
end

endmodule