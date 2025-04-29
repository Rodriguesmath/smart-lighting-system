// This file contains utility functions and tasks used in the testbench. 
// It includes functions for waveform dumping and signal checking to facilitate testing and debugging.

module tb_utils;

  // Função para dump de waveform
  function void dump_waveform(input string filename);
    $dumpfile(filename);
    $dumpvars(0, tb_utils);
  endfunction

  // Task para verificar valores de sinais
  task check_signal(input logic signal, input logic expected_value, input string signal_name);
    if (signal !== expected_value) begin
      $display("Error: %s has unexpected value: %b (expected: %b)", signal_name, signal, expected_value);
    end else begin
      $display("Info: %s has expected value: %b", signal_name, signal);
    end
  endtask

endmodule