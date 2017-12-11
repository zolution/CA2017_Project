# Project 1: Building pipeline processor

> NTU CSIE Computer Architecture, Fall 2017
> Team member: B04902025林品諺  B04902077江緯璿  B04902079甯芝蓶
> https://github.com/zolution/CA2017_Project/tree/master/pj1

In order to decrease the time for debugging, we separated the whole project into several parts. Before moving to next part, we always test and debug first.

# Part 1: Build a full single cycle CPU
## Implementation

This part is mainly based on HW4. However, to support all instruction sets mentioned in the slide, there are still several components need to be implemented/modified, including:

1. Data Memory
  To support `lw` and `sw` instructions, we need this module to support memory access. Because it seems that verilog doesn't have a “memory” data type, so we simply use some registers to implement this unit.
2. ALU and ALU Control
  These modules are almost the same as the version of HW4, the only change is slightly modify the two units to support `beq` instruction. However, when implementing `beq` instruction, we forgot to use the result of ALU unit and added another wire to support the instruction.
3. Control unit
  There are some control signals need to be modified in control unit. Since we now have the data memory, we need to add corresponding control signals such as  `MemtoReg`. Therefore, we modified the connection and control signal types in the control unit, in order to make every component well-functioned.
4. Branching and jumping
  This part is for `beq` and `jr` register. To support these 2 instructions, we used:
  - 2 `MUX`s to select the correct PC (the selection bits are from `branch` and `jump` control signal)
  - an `Adder` to generate the PC after branching
  - a `ShiftLeft` module to generate the PC after jumping
5. CPU
  We need to add some units to support the new instructions. Just lots of simple but tiring works. 

## Difficulties
1. **Unfamiliarity of Git**
  We write our project with git. At first, we hope that this can help merging the works done by different teammates. However, because of our unfamiliarity of git, we spent some time on understanding the different commands of git. Also, we have several commits directly on master, rather than split to different branches. This is not a good habit for using git.
  Solution: Learn to git.
2. **Illustration tables are imprecise**
  The tables in the slides are not complete (ex. `addi` is not mentioned), so we must find out the insufficiency in the content. This took us a plenty of time as well to come over those traps.
3. **Testbench**
  We first build a single cycle version for initial test and data memory test. However, the testbench is different from the pipelined version provided by TA. As a result, we have no choice but to modify the testbench of HW4 to meet our requirement.

## Teamwork
| Team member | Responsibility                                   |
| ----------- | ------------------------------------------------ |
| 林品諺         | Data memory, ALU and ALU Control, Control unit   |
| 江緯璿         | Debugging                                        |
| 甯芝蓶         | Branching and jumping, Connecting CPU, Debugging |

# Part 2: Basic pipelined CPU
## Implemantation
1. **Control signal** 
  Different from HW4, now we have lots of control signals, and we have to handle them for different types of command. Also, the destinations are also different for each signal. Most of them will go to the ID/EX Interface (via MUX8 for hazard detection), while some of them directly connect to the program counter part( `branch` and `jump` ). As a result, we need to map each command to a corresponding control signal combination, and send them to the specified component.
2. **4 Pipelined interfaces**
	The 4 interfaces are mainly array of registers. They stored the input data temporary and forward them out at the next `clk posedge`. Data that are forwarded are listed below:
	1. IFID interface
		- PC
		- instruction
	2. IDEX interface
		- PC
		- `RD_data` and `RS_data` read from the register file
		- Control signals: `RegDst`, `ALUSrc`, `MemtoReg`, `RegWrite`, `MemWrite`, `ExtOp`, `ALUOp`, `MemRead`
		- the sign extended data
		- `write_register`
	3. EXMEM interface
		- PC
		- ALU result
		- write data for data memory
		- Control signals:  `MemtoReg`, `RegWrite`, `MemWrite`, `MemRead`
		- `write_register`
	4. MEMWB interface
		- ALU result
		- data read from data memory
		- Control signals:  `MemtoReg`, `RegWrite`
3. writeback path
  In a pipelined CPU, register file have to wait `write_data`  for 4 cycles. So we forwarded the `write_register` to each interface so that it can arrive the register file with `write_data` simultaneously.

## Difficulties
1. Registers initialization
  Before the 5th cycle, later stages of pipeline are still empty. However, they still have to output SOMETHING or there would be unknown signals everywhere.
  Solution: Set all registers to 0 at the beginning.
2. PC does not work
  This issue is related to the “registers initialization” problem above. All of our interfaces are set to move to the next cycle at every clock pos-edge. However, when the clock start with a 1, the interfaces would be forced to output some signals before being initialized. (Still, unknown signals everywhere… 😞 )
  Solution: Let clock start with a 0, so that there’s time for registers to be initialized.

## Teamwork
| Team member | Responsibility                                    |
| ----------- | ------------------------------------------------- |
| 林品諺         | Debugging                                         |
| 江緯璿         | Control signal on pipeline interfaces, Debugging  |
| 甯芝蓶         | 4 pipeline interfaces, write back path, Debugging |

# Part 3: Dealing with pipeline hazard
## Implemantation
1. Forwarding unit
  Forwarding is one of the methods to solve the pipeline hazards. The forwarding unit checks the registers used by the instructions to decide which data should be forwarded to the ALU. Specifically,  the unit reads the register address from ID/EX, EX/MEM, and MEM/WB interfaces. If the MEM stage or WB stage accesses an register that is going to be fetched by EX stage, then the data should be forwarded to the EX stage.
2. Hazard detection unit
  As the slides suggested, we cannot solve all kinds of hazard by forwarding data. Under such circumstance, we need to stall the pipeline, and this is why we need Hazard Control Unit. Our detection function is based on the class material (p22-25 of 11/08 slides). It reads the `MemRead` signal and the registers read in IF/ID and ID/EX pipeline interface, and then after some judgement, it will send corresponding signal to PC, IF/ID interface, and MUX8 simultaneously to tell those components to stall or not.
3. Flush
  Flush is needed if the branch is wrongly predicted, or a jump command occurs. Therefore, we need to check if these two conditions happen. We connect the `jump` and `beq` signal with an `or` gate with the IF/ID pipeline interface to flush the wrong command set.
4. Variants of MUX
  Now we need more versions of multiplexer since the forward unit, ALU, control unit, etc. need different MUX respectively. As a result, we implement `MUX8` for control signals transmitting and stalling, `MUX32_3` for 3 inputs multiplexer.

## Difficulties
1. Branching & Jumping are moved to IF stage
  During former parts, we implemented the branching-and-jumping-related components in the EX stage. However, they are decided to be moved to the IF stage in the final version. It took a large amount of time dealing with it.
  Solution: Just do it.
2. Many many wire
  When an output signal is forwarded to more than 1 input ports, it should be declared as `wire`. We often forgot to do this, especially for those wires that were only connected to a single input in former parts, but turned out to be complicated in the final version.
  Solution: DEBUG
3. Default test-bench not suitable for some test cases
  The default test-bench stops after 30 cycles. But `Fibonacci_instructions.txt` needs more cycles to complete its task.
  Solution: Set the cycle number to 64 when testing Fibonacci instructions.

## Teamwork
| Team member | Responsibility                                                     |
| ----------- | ------------------------------------------------------------------ |
| 林品諺         | Forwarding unit ( and related connection in CPU ), Final debugging |
| 江緯璿         | Hazard detection unit, Flush ( and related connection in CPU )     |
| 甯芝蓶         | Other connections in CPU, Final debugging, Report writing          |

# Conclusion

Needless to say, Verilog is very difficult and inconvenient for bug tracing. We use lcarus, iverilog and gtkwave to ensure the integrity of our implementation, but the wire connections inside the CPU are so complex that even a tiny mistake can ruin all the results. All in all, this project gives us an opportunity to throughly learn the components of a pipelined CPU from bottom to top. Exhausting though it is, we still learned a lot from it.

# Appendix
## File structure
```
    └── project1_team21_V0
        ├── project1_team21.pdf
        └── code
            ├── ALU.v
            ├── ALU_Control.v
            ├── Adder.v
            ├── CPU.v
            ├── Control.v
            ├── Data_Memory.v
            ├── EXMEM.v
            ├── Forwarding.v
            ├── HazardDetection.v
            ├── IDEX.v
            ├── IFID.v
            ├── Instruction_Memory.v
            ├── MEMWB.v
            ├── MUX32.v
            ├── MUX32_3.v
            ├── MUX5.v
            ├── MUX8.v
            ├── PC.v
            ├── Registers.v
            ├── Shift_left.v
            ├── Sign_Extend.v
            ├── Fibonacci_instruction.txt
            ├── Fibonacci_output.txt
            ├── output.txt
            ├── instruction.txt
            └── testbench.v
```

## Modules not mentioned above
1. Instruction Memory
  As the HW4 described, this is just a memory which saves and loads instructions. We did not make modifications to this component.
2. Sign extend
  We did not make changes to this module, either. The purpose of this module is to extend a signed 16-bit integer to 32-bit signed integer.
3. Registers
  This is a module to save the registers. It can be read and written. It contains 32 Registers for memory and calculation purpose. This module is also not much modified comparing to HW4.
