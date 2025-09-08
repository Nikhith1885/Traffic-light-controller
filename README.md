# 🚦 Traffic Light Controller (Highway & Farm Road)

## 📌 Project Overview
This project implements a **4-state Traffic Light Controller** in Verilog HDL.  
It controls **two roads**:
- **Highway**
- **Farm road**

The system uses:
- **4 FSM states** (`HW_GREEN`, `HW_YELLOW`, `FARM_GREEN`, `FARM_YELLOW`)  
- **2 time intervals** (GREEN duration & YELLOW duration)

---

## 🔧 Features
- Fully synchronous FSM design
- Parameterized time intervals (`GREEN_CYCLES`, `YELLOW_CYCLES`)
- Outputs for each traffic light:
  - Highway: Green, Yellow, Red
  - Farm Road: Green, Yellow, Red
- Testbench included for simulation

---

## 🧩 State Diagram

```text
 HW_GREEN → HW_YELLOW → FARM_GREEN → FARM_YELLOW → (back to HW_GREEN)
