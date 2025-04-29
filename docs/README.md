# Sistema de Iluminação Inteligente

## ✨ Descrição

Este projeto implementa um **sistema de iluminação inteligente** utilizando **SystemVerilog**.
O sistema é capaz de operar de forma **automática**, acionando uma lâmpada ao detectar presença via sensor infravermelho, ou de forma **manual**, permitindo o controle da lâmpada através de um **push-button**.

A troca de modos é realizada com o pressionamento prolongado do botão.

---

## ⚙️ Funcionamento

- **Modo Automático**
  - Lâmpada **liga** ao detectar movimento (sensor de presença ativo).
  - Sem movimento, inicia uma **contagem de 30 segundos** para desligamento.
- **Modo Manual**
  - **Botão** controla diretamente a lâmpada (liga/desliga).
  - Pressão entre **300ms e 5s** altera o estado da lâmpada.
- **Troca de Modo**
  - Pressionar o botão por **5 segundos ou mais** alterna entre automático/manual.
- **LED Indicador**
  - **Ligado:** Modo manual.
  - **Desligado:** Modo automático.

---

## 🛠️ Estrutura do Projeto

```plaintext
SistemaIluminacao/
│
├── src/   
│   ├── maquina_principal.sv   # Máquina de estados principal
│   ├── submodulo_1.sv         # Cronômetro de pressão do botão (Tp)
│   ├── submodulo_2.sv         # Temporizador de ausência de movimento (Tc)
│
├── doc/
│   ├── Projeto 1 – Sistema de iluminação inteligente V1   # Especificação
│   
├── sim/
│   ├── tb_top.sv     # Testbench para a controladora
│   └── tb_utils.sv   # Testbench da máquina principal
├── top.sv
├── README.md
└── Makefile (opcional)
```
