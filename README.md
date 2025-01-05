# FPGA-Based Traffic Light Controller with Smart Parking System

## **Project Overview**
This project implements a **Traffic Light Controller** integrated with a **Smart Parking System** using an FPGA. The system is designed to efficiently manage traffic flow and parking availability in urban environments. The project utilizes modern hardware and software tools for real-time signal control, timing transitions, and parking space management.

---

## **Hardware Used**
1. **FPGA Board**: Xilinx Artix-7  
2. **Development Card**: Aryabhatta Card  
3. **Digital Oscilloscope**: For signal observation and debugging

---

## **Software Used**
1. **Vivado Design Suite 2024.1**: Used for HDL design, synthesis, and implementation.  
2. **Icarus Verilog**: For writing and simulating Verilog code.  
3. **GTKWave**: For waveform analysis.

---

## **Methodology**
The project follows a systematic approach to design and implementation:

1. **Problem Analysis**  
   - Identifying traffic management issues and parking challenges in urban areas.  
   - Proposing an FPGA-based solution for real-time control and monitoring.

2. **Road Layout**  
   - Creating a digital representation of the road intersections and parking zones.  
   - Defining the flow of vehicles and pedestrian pathways.

3. **Traffic Signal Indications**  
   - Designing traffic light sequences for intersections, including red, yellow, and green signals.  
   - Ensuring smooth transitions between states to avoid traffic congestion.

4. **Time Delay and Transitions**  
   - Implementing precise timing mechanisms for signal delays using FPGA clock cycles.  
   - Ensuring synchronization between signals for different lanes.

5. **Smart Parking System**  
   - Monitoring parking slots using sensors and FPGA logic.  
   - Displaying available parking spaces and guiding vehicles accordingly.

---

## **Features**
- Real-time traffic light control with customizable time delays.  
- Smart parking management with automated slot monitoring.  
- Scalable design to adapt to complex road networks.  
- Low power consumption and high efficiency with FPGA technology.

---

## **Getting Started**
### Prerequisites
- Xilinx Vivado 2024.1 installed on your system.  
- Basic understanding of Verilog and digital design concepts.  

### Steps to Run
1. **Design**: Write and simulate Verilog modules for traffic lights and parking logic.  
2. **Synthesize**: Use Vivado to synthesize and implement the design on Artix-7 FPGA.  
3. **Verify**: Test the signals and transitions using GTKWave and a digital oscilloscope.  
4. **Deploy**: Flash the design onto the FPGA and connect the hardware setup.  

---

## **Future Enhancements**
- Integration with IoT for remote monitoring and control.  
- Real-time analytics and reporting on traffic and parking usage.  
- Adaptive traffic signals based on real-time traffic density. 
