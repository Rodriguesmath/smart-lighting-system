module submodulo_3 #(
    parameter AUTO_SHUTDOWN_T = 30000
  )(
    input logic clk,
    input logic rst,
    input logic infravermelho,
    output logic C
  );
  
    typedef enum logic [1:0] {
        INICIAL,
        CONTANDO,
        TEMP
    } state_t;
  
    state_t estado, prox_estado;
    logic [15:0] Tc; // contador de tempo (suficiente para 30 mil ciclos)
  
    // Lógica de transição de estado
      // Lógica de transição de estado
  always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
          estado <= INICIAL;
          Tc <= 0;
      end else begin
          estado <= prox_estado;
  
          // Atualiza o contador
          if (estado == CONTANDO) begin
              if (infravermelho) begin
                  Tc <= 0; // Reinicia se o infravermelho voltar
              end else if (Tc < AUTO_SHUTDOWN_T - 1) begin
                  Tc <= Tc + 1; // Incrementa o contador
              end
          end else begin
              Tc <= 0; // Zera o contador em outros estados
          end
      end
  end
  
    //aqui você lida em como a maquina faz as transições
  // Lógica de transição de estados
    always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
          prox_estado <= INICIAL;
      end else begin
          case (estado)
              INICIAL: begin
                  if (infravermelho) begin
                      prox_estado <= INICIAL; // Permanece no estado INICIAL
                  end else begin
                      prox_estado <= CONTANDO; // Transita para o estado CONTANDO
                  end
              end
              CONTANDO: begin
                  if (infravermelho) begin
                      prox_estado <= INICIAL; // Retorna ao estado INICIAL
                  end else if (Tc == AUTO_SHUTDOWN_T) begin
                      prox_estado <= TEMP; // Transita para o estado TEMP
                  end else begin
                      prox_estado <= CONTANDO; // Permanece no estado CONTANDO
                  end
              end
              TEMP: begin
                  prox_estado <= INICIAL; // Retorna ao estado INICIAL
              end
              default: begin
                  prox_estado <= INICIAL; // Estado padrão
              end
          endcase
      end
  end
  
    // Lógica do contador e sinal de saída
  always_comb begin
      case (estado)
        INICIAL: begin
          C = 0;
        end
        CONTANDO: begin
          if (Tc == AUTO_SHUTDOWN_T - 1) begin
            C = 1; // Ativa C quando o contador atinge o limite
          end else begin
            C = 0;
          end
        end
        TEMP: begin
          C = 1; // Mantém C ativo no estado TEMP
        end
        default: begin
          C = 0;
        end
      endcase
    end
  
  endmodule