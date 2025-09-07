# FFT Design & ASIC Implementation (Radix-2 DIT, N=8)

This repository contains the full flow of designing, verifying, and implementing an **8-point Radix-2 Decimation-in-Time (DIT) FFT** core — starting from MATLAB modeling to RTL verification and ASIC implementation using OpenLane.

---

## 📌 Project Overview
- **Goal**: Implement an 8-point radix-2 FFT pipeline in hardware, verify against MATLAB reference, and complete an ASIC flow.
- **Steps**:
  1. MATLAB fixed-point modeling  
  2. RTL modeling in SystemVerilog  
  3. Verification with testbench & code coverage  
  4. ASIC implementation using OpenLane (Sky130 PDK)

---

## 🔬 System Modeling
- Developed FFT algorithm in MATLAB:
  - Functions:
    - `fft_mytypes` → defines number formats  
    - `fft_DIT_algo` → radix-2 DIT FFT (3 stages, bit-reversal)  
  - Explored `double`, `single`, and `fixed-point` types.
  - Generated binary files for input/output.
- Measured **Error Norm** and **SQNR**:  
  - Error range ≈ 1e-04 (acceptable)  
  - Average SQNR over 10k seeds ≈ **94.41 dB** (excellent quality)

---

## 🖥️ RTL Implementation
- **Language**: SystemVerilog  
- **FFT Architecture**:  
  - Radix-2, fully parallel pipeline  
  - Input: Natural order  
  - Output: Natural order  
- **Latency**: 4 cycles until first output, then 1 sample per cycle (pipelined).  

---

## ✅ Verification
- Testbench generated **1,000,000 random inputs** from MATLAB and compared RTL vs MATLAB FFT.
- **Code Coverage**:
  - DUT (fft_dit_pipeline):
    - Branch: 100%  
    - Statement: 100%  
    - Toggle: 100%  
  - Testbench (fft_dit_tb):
    - Branch: 83.3%  
    - Statement: 96.2%  
    - Toggle: 100%  
    - Condition: 20% (checker condition not triggered since no mismatches occurred)

---

## ⚙️ ASIC Flow (OpenLane, Sky130 PDK)
- **Technology**: SkyWater 130nm (Sky130A)  
- **Standard Cell Libraries**:  
  - `sky130_fd_sc_hd` → High Density  
  - `sky130_fd_sc_hs` → High Speed  
  - `sky130_fd_sc_lp` → Low Power  

- **Reports**:
  - Core area: **588.8µm × 576.64µm**  
  - Clock period: **25 ns**  
  - WNS = 6.66 ns → Max frequency ≈ **54.5 MHz**  
  - Post-route utilization: ~99,225 µm²  
  - Power analysis: clean before/after CTS  
  - No setup/hold violations  
  - No DRC violations  

  
---

## 📊 Key Results
- **High-quality FFT core** with SQNR > 90 dB  
- **Verified RTL** against MATLAB model with full coverage on DUT  
- **ASIC-ready implementation** on Sky130 with clean timing/DRC  

---

## 🚀 Future Work
- Extend to larger FFT sizes (16, 32, 64 points)  
- Explore SDF/MDC architectures for scalability  
- Optimize power/area for low-power applications  

---

## 🙌 Acknowledgements
- SkyWater Open PDK  
- OpenLane ASIC flow  
- QuestaSim for verification  
- MATLAB/Fixed-Point Toolbox  

---

📌 Author: **Youssef Ashraf**  
📅 Date: September 2025


---

## 📂 Repository Structure
