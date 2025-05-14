package tb_utils;

  // Task para resetar o sistema
  task automatic reset_system(output logic RESET);
    begin
      RESET = 1;
      #500 RESET = 0; // 500 ms por questão de segurança
    end
  endtask

  // Task para simular o modo automático com movimento
  task automatic modo_automatico_com_movimento(output logic INFRAVERMELHO);
    begin
      $display("\n--- MODO AUTOMÁTICO COM MOVIMENTO ---");
      #1 INFRAVERMELHO = 1;
      #2 INFRAVERMELHO = 0;
      #100;
    end
  endtask

  // Task para alternar o modo
  task automatic alternar_modo(output logic PUSH_BUTTON);
    begin
      $display("\n--- ALTERNANDO PARA MODO MANUAL (B_STATE) ---");
      #1001 PUSH_BUTTON = 1;
      #10000 PUSH_BUTTON = 0;
    end
  endtask

  // Task para testar o debounce
  task automatic teste_debounce(output logic PUSH_BUTTON);
    begin
      $display("\n--- CONTROLE MANUAL DA LÂMPADA ---");
      #1002 PUSH_BUTTON = 1;
      #600 PUSH_BUTTON = 0;
    end
  endtask

  // Task para ligar a lâmpada manualmente
  task automatic ligar_manual_lampada(output logic PUSH_BUTTON);
    begin
      $display("\n--- CONTROLE MANUAL DA LÂMPADA ---");
      #10 PUSH_BUTTON = 1;
      #301 PUSH_BUTTON = 0;
    end
  endtask

// Task para pausa com tempo configurável
task automatic pausa(input int tempo);
    begin
        #tempo;
    end
endtask

endpackage