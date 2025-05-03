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
    current_state <= INICIAL;
    Tp <= 0;
  end else begin
    current_state <= next_state;
    if (current_state == DB || current_state == B_STATE || current_state == A_STATE) begin
      Tp <= Tp + 1;
    end else begin
      Tp <= 0;
    end
  end
end

always_comb begin

  case (current_state)
    INICIAL: begin
      A = 0;
      B = 0;
      if (push_button) next_state = DB;
    end

    DB: begin
      A = 0;
      B = 0;
      if (Tp < DEBOUNCE_P) next_state = DB;
      else if (!push_button) next_state = INICIAL;
      else if (Tp >= 300) next_state = B_STATE;
    end

    B_STATE: begin
      A = 0;
      B = 0;
      if (Tp < SWITCH_MODE_MIN_T) next_state = B_STATE;
      else if(!push_button) begin
      next_state =  TEMP;
      B = 1;
      end else if(Tp >= 5000) next_state = A_STATE;
    end

    A_STATE: begin
      A = 0;
      B = 0;
      if (!push_button) begin
       next_state = TEMP;
       A = 1;
      end else if (Tp >= 5000) next_state = A_STATE;

    end

    TEMP: begin
      A = A;
      B = B;
      next_state = INICIAL;
    end

    default: begin
    next_state = INICIAL;
    A = 0;
    B = 0;
    end
  endcase
end

endmodule