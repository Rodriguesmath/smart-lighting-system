module maquina_principal (
    input logic clk, rst, a, b, c, d,
    output logic led, saida
);

  // Definição dos estados da máquina de estados principal
typedef enum logic [2:0] {
  LAMPADA_DESLIG_AUTOMATICA,  // Lâmpada desligada no modo automático
  LAMPADA_LIG_AUTOMATICA,     // Lâmpada ligada no modo automático
  LAMPADA_DESLIG_MANUAL,      // Lâmpada desligada no modo manual
  LAMPADA_LIG_MANUAL          // Lâmpada ligada no modo manual
} state_t;

state_t current_state, next_state;  // Estado atual e próximo estado

// Máquina de estados sequencial (atualização do estado atual)
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    current_state <= LAMPADA_DESLIG_AUTOMATICA;  // Reset: estado inicial
  end else begin
    current_state <= next_state;                // Atualiza o estado atual
  end
end

// Máquina de estados combinacional (lógica de transição de estados)
always_comb begin
  // Valores padrão
  next_state = current_state;
  led = 0;
  saida = 0;

  case (current_state)
    LAMPADA_DESLIG_AUTOMATICA: begin
      if (a) begin
        next_state = LAMPADA_LIG_AUTOMATICA;    // Transição para lâmpada ligada no modo automático
        led = 0;
        saida = 1;
      end else if (b) begin
        next_state = LAMPADA_DESLIG_MANUAL;     // Transição para lâmpada desligada no modo manual
        led = 1;
        saida = 0;
      end
    end

    LAMPADA_LIG_AUTOMATICA: begin
      if (c) begin
        next_state = LAMPADA_DESLIG_AUTOMATICA; // Transição para lâmpada desligada no modo automático
        led = 0;
        saida = 0;
      end else if (d) begin
        next_state = LAMPADA_LIG_MANUAL;       // Transição para lâmpada ligada no modo manual
        led = 0;
        saida = 1;
      end
    end

    LAMPADA_DESLIG_MANUAL: begin
      if (a) begin
        next_state = LAMPADA_LIG_AUTOMATICA;   // Transição para lâmpada ligada no modo automático
        led = 0;
        saida = 1;
      end else if (b) begin
        next_state = LAMPADA_LIG_MANUAL;       // Transição para lâmpada ligada no modo manual
        led = 1;
        saida = 1;
      end
    end

    LAMPADA_LIG_MANUAL: begin
      if (b) begin
        next_state = LAMPADA_DESLIG_MANUAL;    // Transição para lâmpada desligada no modo manual
        led = 1;
        saida = 0;
      end else if (c) begin
        next_state = LAMPADA_DESLIG_AUTOMATICA; // Transição para lâmpada desligada no modo automático
        led = 0;
        saida = 0;
      end
    end

    default: begin
      next_state = LAMPADA_DESLIG_AUTOMATICA;  // Estado padrão (segurança)
    end
  endcase
end
endmodule