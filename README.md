# Secure-STR-SSN
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
![RT-Level: VHDL](https://img.shields.io/badge/RT--Level-VHDL-8877cc.svg)

## 🔒 Overview

The project implements a security enhancement for the Streaming Scan Network (SSN) architecture using a novel Secure Test Register (STR)-based user authorization mechanism.

### ✨ Key Features

- STR-based scan access control mechanism
- On-chip MISR-based key generation
- Binary authorization model to mitigate side-channel leakage
- Minimal hardware overhead for secure integration

## 📂 Directory Structure
<pre>
├── VHDL/
│   ├── Design.vhd                  # Top-level design integrating STR logic
│   ├── ComparatorWithCounter.vhd  # Compares MISR and user key with counter mechanism
│   ├── Secure_TDR_bit.vhd         # VHDL entity for secure STR bit behavior
│   ├── TAP_controller.vhd         # TAP controller to drive IJTAG scan flow
├── Testbench/
│   └── Design_tb.vhd              # Testbench for simulating the design
├── docs/
│ └── architecture_diagram.pdf # STR-based SSN block diagram (from the paper)
└── README.md
</pre>

## 🛠️ Requirements
- **Language**: VHDL
- **Simulator**: Xilinx Vivado 2020.4 Simulator
- **Synthesis Tool**: Xilinx Vivado 2020.4 Simulator
- **Target**: FPGA or ASIC prototype (tested on Xilinx PYNQ-z2)

