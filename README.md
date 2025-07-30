# Secure-STR-SSN

## 🔒 Overview

The project implements a security enhancement for the Streaming Scan Network (SSN) architecture using a novel Secure Test Register (STR)-based user authorization mechanism.

### ✨ Key Features

- STR-based scan access control mechanism
- On-chip MISR-based key generation
- Binary authorization model to mitigate side-channel leakage
- Minimal hardware overhead for secure integration

## 📂 Directory Structure
<pre>
├── src/
│ ├── str_controller.vhd # STR logic for authorization and MISR-based key generation
│ ├── misr_generator.vhd # MISR module with fixed polynomial and tap points
│ ├── ssh_register_block.vhd # IJTAG static register with STR-bits
│ └── top_level_ssh.vhd # Top-level SSH wrapper integrating STR logic
├── sim/
│ └── testbench.vhd # Basic testbench for simulating STR-based authorization
├── docs/
│ └── architecture_diagram.pdf # STR-based SSN block diagram (from the paper)
└── README.md
<\pre>
