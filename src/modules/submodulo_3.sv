module submodulo_3 #(
  parameter AUTO_SHUTDOWN_T = 30000
)(
  input logic clk,
  input logic rst,
  input logic infravermelho,
  output logic C
);

  typedef enum logic [1:0] {
      RESET,
      INICIAL,
      CONTANDO,
      TEMP
  } state_t;

  state_t estado, prox_estado;
  logic [15:0] Tc; // contador de tempo (suficiente para 30 mil ciclos)

  // Lógica de transição de estado
  always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
          estado <= RESET;
      end else begin
          estado <= prox_estado;
      end
  end

  // Lógica do contador e sinal de saída
  always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
          Tc <= 0;
          C <= 0;
      end else begin
          case (estado)
              RESET: begin
                  Tc <= 0;
                  C <= 0;
              end
              INICIAL: begin
                  Tc <= 0;
                  C <= 0;
              end
              CONTANDO: begin
                  if (infravermelho) begin
                      Tc <= 0; // Reinicia se o infravermelho voltar
                      C <= 0;
                  end else if (Tc < AUTO_SHUTDOWN_T - 1) begin
                      Tc <= Tc + 1; // Incrementa o contador
                      C <= 0;
                  end else begin
                      Tc <= 0; // Zera o contador ao atingir o limite
                      C <= 1; // Ativa C
                  end
              end
              TEMP: begin
                  // Estado temporário para emissão de pulso
                  C <= 1;
              end
              
          endcase
      end
  end

  // Lógica do próximo estado
  always_comb begin
      case (estado)
          RESET:     prox_estado = INICIAL;
          INICIAL:   prox_estado = (infravermelho) ? INICIAL : CONTANDO;
          CONTANDO:  prox_estado = (infravermelho) ? INICIAL :
                                    (Tc == AUTO_SHUTDOWN_T) ? TEMP : CONTANDO;
          TEMP:      prox_estado = INICIAL;
          default:   prox_estado = RESET;
      endcase
  end

endmodule