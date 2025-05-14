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


  always_ff @(posedge clk or posedge rst) begin:state_block
    if (rst) begin
      current_state <= INICIAL;
    end else begin
      current_state <= next_state;
    end
  end:state_block

  always_ff @(posedge clk or posedge rst) begin:counter
    if (rst) begin
      Tp <= 0;
    end else begin
      Tp <= Tp;
      case (next_state)
        DB, B_STATE, A_STATE: begin
          Tp <= Tp + 1;
        end
        TEMP: begin
          Tp <= 0;
        end
        default: begin
          Tp <= 0;
        end
      endcase
    end
  end:counter

  always_ff @(posedge clk or posedge rst) begin:FSM
    if (rst) begin
      next_state <= INICIAL;
    end else case (current_state)
      INICIAL: begin
        if (push_button) next_state <= DB; //PB
        else next_state <= INICIAL; //notPB
      end
      DB: begin
        if (Tp + 3 < DEBOUNCE_P) next_state <= DB; // tp < 300
        else if (!push_button) next_state <= INICIAL; //notPB
        else next_state <= B_STATE; // tp >= 300
      end

      B_STATE: begin
        if (!push_button) next_state <= TEMP; //notPB
        else if (Tp + 2 >= SWITCH_MODE_MIN_T) next_state <= A_STATE; //tp >= 5000
        else next_state <= B_STATE; //tp < 5000
      end

      A_STATE: begin
        if (!push_button) next_state <= TEMP; //notPB
        else next_state <= A_STATE; //tp >= 5000
      end

      TEMP: begin
        next_state <= INICIAL; //clk
      end
      default: begin
        next_state <= INICIAL; //clk
      end

    endcase
  end:FSM

  always_comb begin:outputs

    case (next_state)
      INICIAL: begin
        A = 0;
        B = 0;
        if(current_state == TEMP) begin
          A = A;
          B = B;
        end else begin
          A = 0;
          B = 0;
        end
      end
      TEMP: begin
        if (current_state == A_STATE) begin
          A = 1;
          B = 0;
        end else if (current_state == B_STATE) begin
          A = 0;
          B = 1;
        end else begin
          A = 0;
          B = 0;
        end
      end
      default: begin
        A = 0;
        B = 0;
      end
    endcase
  end:outputs
endmodule