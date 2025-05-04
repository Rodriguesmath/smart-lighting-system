module submodulo_1 (
  input logic clk, rst, a, b, c, d,
  output logic led, saida
);

typedef enum logic [2:0] {
  LAMPADA_DESLIG_AUTOMATICA,
  LAMPADA_LIG_AUTOMATICA,
  LAMPADA_DESLIG_MANUAL,
  LAMPADA_LIG_MANUAL
} state_t;

state_t current_state, next_state;


always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    current_state <= LAMPADA_DESLIG_AUTOMATICA;
  end else begin
    current_state <= next_state;
  end
end

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    next_state <= LAMPADA_DESLIG_AUTOMATICA;
  end else begin
    case (current_state)
      LAMPADA_DESLIG_AUTOMATICA: begin
        if (a) next_state <= LAMPADA_DESLIG_MANUAL; // Alterna para modo manual
        else if (d) next_state <= LAMPADA_LIG_AUTOMATICA; // Liga a lâmpada no modo automático
      end
      LAMPADA_LIG_AUTOMATICA: begin
        if (a) next_state <= LAMPADA_LIG_MANUAL; // Alterna para modo manual
        else if (c) next_state <= LAMPADA_DESLIG_AUTOMATICA; // Desliga a lâmpada no modo automático
      end
      LAMPADA_DESLIG_MANUAL: begin
        if (a) next_state <= LAMPADA_DESLIG_AUTOMATICA; // Alterna para modo automático
        else if (b) next_state <= LAMPADA_LIG_MANUAL; // Liga a lâmpada no modo manual
      end
      LAMPADA_LIG_MANUAL: begin
        if (a) next_state <= LAMPADA_LIG_AUTOMATICA; // Alterna para modo automático
        else if (b) next_state <= LAMPADA_DESLIG_MANUAL; // Desliga a lâmpada no modo manual
      end
      default: begin
        next_state <= LAMPADA_DESLIG_AUTOMATICA;
      end
    endcase
  end
end

always_comb begin

  // Define os valores das saídas com base no estado atual
  case (current_state)
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
end

endmodule