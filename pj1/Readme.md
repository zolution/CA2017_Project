# Project 1: Building pipeline processor

<div align=left>NTU CSIE<br>
Computer Architecture<br>
Fall 2017<br>
CSIE3340, Class 01<br>

#### Reference Link

https://paper.dropbox.com/doc/CA-Project1-i18R0VQ40WG0J3tI4dw42

# Progress

####Step 1: Build a full single cycle CPU

We tried to build a full-functioned single cycle CPU which support all instruction set mentioned in the slide. However, we met several difficulties.

1. Data_memory malfunction
   We found some bugs in our data_memory, which took us lots of time to find out a trivial bug.
2. Illustration graphes and tables are imprecise
   The graphes and tables illustrated in the slides are not complete, so we must find out the mistakes and insufficience in the content. This took us a plenty of time as well to come over those traps.
3. Infinite debugging
   Needless to say, Verilog is very difficult for bug tracing. We use lcarus iverilog and gtkwave to ensure the integrity of our implementation, but the wire connection inside the CPU is so complex that even a tiny mistake can ruin all the results.

The followings are the modified/added files in this step.

- Data_memory
- ALU/ALU_Control
- Control
- Testbench
- CPU
- Shift_left