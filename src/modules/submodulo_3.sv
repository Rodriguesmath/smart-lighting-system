module submodulo_3 #(
  parameter AUTO_SHUTDOWN_T = 30000
) (
  input logic clk, rst, infravermelho,
  output logic C
);

typedef enum logic [1:0] {
  INICIAL,
  CONTANDO,
  TEMP
} state_t;

state_t current_state, next_state;
logic [15:0] Tc;


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

always_comb begin

  case (current_state)
    INICIAL: begin
      if (!infravermelho) next_state = CONTANDO;
    end

    CONTANDO: begin
      if (Tc < AUTO_SHUTDOWN_T) next_state = CONTANDO;
      else if (infravermelho) next_state = INICIAL;
      else begin
        C = 1;
        next_state = TEMP;
      end
      
    end

    TEMP: begin
      next_state = INICIAL;
    end

    default: next_state = INICIAL;
  endcase
end

endmodule