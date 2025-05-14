module submodulo_1 (
  input logic clk, rst, a, b, c, d,
  output logic led, saida
);

  typedef enum logic [1:0] {
    LAMPADA_DESLIG_AUTOMATICA,
    LAMPADA_LIG_AUTOMATICA,
    LAMPADA_DESLIG_MANUAL,
    LAMPADA_LIG_MANUAL
  } state_t;

  state_t current_state, next_state;


  always_ff @(posedge clk or posedge rst) begin:State_block
    if (rst) begin
      current_state <= LAMPADA_DESLIG_AUTOMATICA;
    end else begin
      current_state <= next_state;
    end
  end:State_block

  always_ff @(posedge clk or posedge rst) begin:FSM
    if (rst) begin
      next_state <= LAMPADA_DESLIG_AUTOMATICA;
    end else begin
      case (current_state)
        LAMPADA_DESLIG_AUTOMATICA: begin
          if (a) next_state <= LAMPADA_DESLIG_MANUAL; // a
          else if (d) next_state <= LAMPADA_LIG_AUTOMATICA; // d
          else next_state <= next_state; // Permanece no estado atual
        end
        LAMPADA_LIG_AUTOMATICA: begin
          if (a) next_state <= LAMPADA_DESLIG_MANUAL; // a
          else if (c) next_state <= LAMPADA_DESLIG_AUTOMATICA; // c
          else next_state <= next_state; // Permanece no estado atual
        end
        LAMPADA_DESLIG_MANUAL: begin
          if (a) next_state <= LAMPADA_LIG_AUTOMATICA; // a
          else if (b) next_state <= LAMPADA_LIG_MANUAL; // b
          else next_state <= next_state; // Permanece no estado atual
        end
        LAMPADA_LIG_MANUAL: begin
          if (a) next_state <= LAMPADA_LIG_AUTOMATICA; // a
          else if (b) next_state <= LAMPADA_DESLIG_MANUAL; // b
          else next_state <= next_state; // Permanece no estado atual
        end
        default: begin
          next_state <= LAMPADA_DESLIG_AUTOMATICA;
        end
      endcase
    end
  end:FSM

  always_comb begin:Outputs

    case (next_state)
      LAMPADA_DESLIG_AUTOMATICA: begin
        led = 0;
        saida = 0;
      end
      LAMPADA_LIG_AUTOMATICA: begin
        led = 0;
        saida = 1;
      end
      LAMPADA_DESLIG_MANUAL: begin
        led = 1;
        saida = 0;
      end
      LAMPADA_LIG_MANUAL: begin
        led = 1;
        saida = 1;
      end
      default: begin
        led = 0;
        saida = 0;
      end
    endcase
  end:Outputs

endmodule