# lti-circuits-simulator
LTI Circuits Simulator Software

This program is able to simulate any circuit containing linear elements. You can easily build your own circuits using iCircuitMaker and generate the corresponding file to be used for analysis. This program supports circuits built with these following elements :
* Linear resistor
* Linear capacitor
* Linear inductor
* Empty (short-circuited) branch
* Independent voltage source
* Independent current source
* All types of dependent voltage sources
* All types of dependent current sources
* Coupled inductor
* Gyrator

The simulation is taken place in two main steps :
1. Build the circuit that you want to do simulation on using iCircuitMaker application and save the output file.
2. Enter the name of the generated file in the previous step into the "SETTING INPUT" section of *project.m* MATLAB file. Then click **Run** and the simulation will begin.

This was originally supposed to be a MATLAB project for Electrical Circuits II course at Shiraz University which was lectured by Dr. Mohammad Ali Masnadi-Shirazi back in Spring 2016 semester. I implemented it using both Visual Basic (for iCircuitMaker) and MATLAB (for the simulation core). The project guide and final program help are also included (in Persian).
