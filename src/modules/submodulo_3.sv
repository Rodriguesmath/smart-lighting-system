module submodulo_3 #(
  parameter AUTO_SHUTDOWN_T = 30000
)(
  input logic clk,
  input logic rst,
  input logic infravermelho,
  input logic enable,
  output logic C
  
);

  typedef enum logic [1:0] {
    INICIAL,
    CONTANDO,
    TEMP
  } state_t;

  state_t estado, prox_estado;
  int Tc; // contador de tempo (suficiente para 30 mil ciclos)

  always_ff @(posedge clk or posedge rst) begin:state_block
    if (rst) begin
      estado <= INICIAL;
    end else begin
      estado <= prox_estado;
    end
  end:state_block

  always_ff @(posedge clk or posedge rst) begin:counter
    if (rst) begin
      Tc <= 0; // Zera o contador no reset
    end else begin
      if (prox_estado == CONTANDO) begin
        if (infravermelho) begin
          Tc <= 0; // Reinicia se o infravermelho voltar
        end else if ((Tc < AUTO_SHUTDOWN_T - 1) && enable) begin
          Tc <= Tc + 1; // Incrementa o contador
        end
        else begin
          Tc = 0;
        end
      end else begin
        Tc <= 0; // Zera o contador em outros estados
      end

    end
  end:counter

  // Lógica de transição de estados
  always_ff @(posedge clk or posedge rst) begin:FSM
    if (rst) begin
      prox_estado <= INICIAL;
    end else begin
      case (estado)
        INICIAL: begin
          if (infravermelho && C == 0) begin
            prox_estado <= INICIAL; // Permanece no estado INICIAL
          end else begin
            prox_estado <= CONTANDO; // !infra
          end
        end
        CONTANDO: begin
          if (infravermelho) begin
            prox_estado <= INICIAL; //infra
          end else if (Tc == AUTO_SHUTDOWN_T) begin
            prox_estado <= TEMP; // Tc == 30000
          end else begin
            prox_estado <= CONTANDO; //ninfra
          end
        end
        TEMP: begin
          prox_estado <= INICIAL; // clk
        end
        default: begin
          prox_estado <= INICIAL; // Estado padrão
        end
      endcase
    end
  end:FSM

  always_comb begin:outputs
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
  end:outputs

endmodule