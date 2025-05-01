module module_2 #(
    parameter AUTO_SHUTDOWN_T = 30000
)(
    input wire clk, rst,
    input logic infravermelho,
    output logic C
);

   // Definição dos estados da máquina de estados
typedef enum logic [1:0] {
  INICIAL,   // Estado inicial
  CONTANDO   // Estado de contagem
} state_t;

state_t current_state, next_state;   // Estado atual e próximo estado
logic [15:0] Tc;                     // Contador de tempo

// Máquina de estados sequencial (atualização do estado atual e contador)
always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    current_state <= INICIAL;        // Reset: volta ao estado inicial
    Tc <= 0;                         // Zera o contador
  end else begin
    current_state <= next_state;     // Atualiza o estado atual
    if (current_state == CONTANDO) begin
      Tc <= Tc + 1;                  // Incrementa o contador no estado CONTANDO
    end else begin
      Tc <= 0;                       // Zera o contador nos outros estados
    end
  end
end

// Máquina de estados combinacional (lógica de transição de estados)
always_comb begin
  // Valores padrão
  next_state = current_state;
  C = 0;

  case (current_state)
    INICIAL: begin
      if (!infravermelho) begin
        next_state = CONTANDO;       // Transição para o estado CONTANDO quando o sinal de infravermelho é perdido
      end
    end

    CONTANDO: begin
      if (Tc < AUTO_SHUTDOWN_T) begin
        next_state = CONTANDO;       // Permanece no estado CONTANDO enquanto Tc < AUTO_SHUTDOWN_T
      end else begin
        next_state = INICIAL;        // Volta ao estado INICIAL quando Tc == AUTO_SHUTDOWN_T
        C = 1;                       // Define a saída C como 1 (desliga a luz)
      end
      if (infravermelho) begin
        next_state = INICIAL;        // Volta ao estado INICIAL se o sinal de infravermelho retornar
      end
    end

    default: begin
      next_state = INICIAL;          // Estado padrão (segurança)
    end
  endcase
end

endmodule