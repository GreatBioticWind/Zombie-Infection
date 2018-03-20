# Zombie-Infection
A SML program that implements basic epidemic models

                              CS 355, Lab 1: SML/NJ

    This collection of assignments attempt to implement the outbreak models outlined
    in the paper "When Zombies Attack!" in the Standard ML language.

    The outbreak models implemented are as follows:
    
        SZR  - base.sml
        SIZR - latentInfection.sml

## Getting Started

    These programs are designed to conform to the Standard ML '97 revision of the SML language. 
    It can theoretically be compiled in any SML '97 environment however, it has only been tested 
    using SML/NJ v110 release and the MLton compiler.

    This software is run from the command line and outputs all results to the terminal using the 
    top-level print function. 

## Prerequisites

    1. SML/NJ v110.78
       This package contains the SML Basis library needed to compile the software.

       
    2. MLton v20180207
       The MLton compiler is the only verified compiler for this software. Although any SML 
       compliant compiler should work.

    Setup on Ubuntu:
        
        `apt-get install smlnj`
       
        `apt-get install mlton`
       
## Compiling and Running

    Use the following commands to compile and run software using MLton:

        `mlton <file_name>`
        `./<file_name>` 

## Credits and Sources

    The paper this software is based on can be found as follows:

       Munz, P., Hudea, I., Imad, J., & Smith, R. (2008). WHEN ZOMBIES ATTACK !:
       MATHEMATICAL MODELLING OF AN OUTBREAK OF ZOMBIE INFECTION.
       Infectious Disease Modelling Research Progress, 133-156. Retrieved February $
       https://mysite.science.uottawa.ca/rsmith43/Zombies.pdf

    Credit to the papers author P. Munz for devising the MATLAB code of the
    ODE's that were used as a reference to implement these models in SML.

    Created by: Cody N, 8 Feb 2018.
