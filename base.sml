(* base.sml
 * 
 * This program simulates a Zombie outbreak by implementing the base model ODEs found in the paper
 * "When zombies attack!: Mathematical modelling of an outbreak of zombie infection"
 *
 *     Munz, P., Hudea, I., Imad, J., & Smith, R. (2008). WHEN ZOMBIES ATTACK !:
 *     MATHEMATICAL MODELLING OF AN OUTBREAK OF ZOMBIE INFECTION.
 *     Infectious Disease Modelling Research Progress, 133-156. Retrieved February 1, 2018, from
 *     https://mysite.science.uottawa.ca/rsmith43/Zombies.pdf
 * 
 * Created by: Cody Nicolaou, 8 Feb 2018.
*)


(*Seed vars for the simulation*)

val M = 500      (*Initial Human Population (Meatbags)*)
val Z = 0        (*Initial Zombie Population*)
val D = 0        (*Initial Dead Population*)
val a = 0.005    (*Zombie destruction rate*)
val b = 0.0095   (*Zombie conversion rate*)
val z = 0.0001   (*Zombie resurrection rate*)
val d = 0.0001   (*Natural population death rate*)
val t = 20.0     (*Simulation duration*)
val dt = 1.0     (*Simulation step time*)

(*Calculated vars*)
val i = Real.ceil(t/dt)      (*Number of steps in a simulation run*)


(* Population arrays, each index represents a single step of the simulation (i)
 * Each array is initialized to a length of i and populated with zeros.
*)
val meatbags = RealArray.array(i, 0.0 );
val zombies = RealArray.array(i, 0.0 );
val dead = RealArray.array(i, 0.0 );

(*Text and  I/O funcions*)  
fun getArrValue (n, arr, name)=
    let
        val temp = RealArray.sub(arr, n)
    in
        print ("\t" ^ name ^ ": " ^ Real.toString(temp) ^ "\n")
    end;
  
fun printArr (i, n, arr)=
    let
        val temp = RealArray.sub(arr, i)
    in (
        print (Real.toString(temp) ^ ", ");
        if ((i) < n) then
            printArr ((i+1), n, arr)
        else
            print "\n"
    )
    end;

(*Tick Functions*)

(* meatbagPopTick (n)
 * Takes an Int n and updates the Meatbag[n] array according to the ODE.
 * On n=0 the initial popuation of humans (M) is set.
 * If the new calculated population of humans at step n is <0 the function leaves meatbags[n]=0.
*)
fun meatbagPopTick n=
    (*On first tick initialize meatbags[0] to Population*)
    if (n = 0) then (
        RealArray.update(meatbags, 0, Real.fromInt(M));
        getArrValue(n, meatbags, "Meatbags")
    ) else
    (*Every other tick*)
    let
        val si = RealArray.sub(meatbags, n-1)
        val zi = RealArray.sub(zombies, n-1)
        (*Meatbags[n] = Meatbags[n-1] - StepTime * (Zombified meatbags)*)
        val new = (si - (dt * (b * si * zi) ) )
    in
        if (Real.ceil(new) > 0) then (
            RealArray.update(meatbags, n, new);
            getArrValue(n, meatbags, "Meatbags")
        ) else (
           (*Leave meatbags[n] = 0*)
           print "\tEveryone is dead\n"
        )
    end;                                      
                                              
(* zombiePopTick (n) 
 * Takes an Int n and updates the Dead[n] array according to the ODE.
 * On n=0 the initial popuation of zombies (Z) is set.
 * If the new calculated population of zombies at step n is <0 the function leaves zombies[n]=0.
*)                                         
fun zombiePopTick n=
    if (n = 0) then (
        RealArray.update(zombies, 0, Real.fromInt(Z));
        getArrValue(n, zombies, "Zombies")
    ) else                          
    let                                        
        val si = RealArray.sub(meatbags, n-1)    
        val zi = RealArray.sub(zombies, n-1)     
        val di = RealArray.sub(dead, n-1)

        (*Zombies[n] = Zombies[n-1] + StepTime * (NewZombiesFromMeatbags - ZombiesKilled + RisenDead)*)        
        val new = ( zi + (dt *( (b * si * zi) - (a * si * zi) + (z * di) ) ) )
    in
        if (Real.ceil(new) > 0) then (                                           
            RealArray.update(zombies, n, new);
            getArrValue(n, zombies, "Zombies")
        ) else (
            (*Leave Zombies[n] = 0*)
            print "\tThere are no zombies, yet\n"
        )
    
    end;                                       
                                               
(* deadPopTick (n)
 * Takes and Int n and updates the dead[n] array according to the ODE.
 * On n=0 the initial population of dead (D) is set at dead[0].
 * If the new calculated population of dead at step n is <0 the function leaves dead[n]=0.
*)                                           
fun deadPopTick n=
    if (n = 0) then (
        RealArray.update(dead, 0, Real.fromInt(D));
        getArrValue(n, dead, "Dead")
    ) else                             
    let                                       
        val si = RealArray.sub(meatbags, n-1)    
        val zi = RealArray.sub(zombies, n-1)     
        val di = RealArray.sub(dead, n-1)      
        (*Dead[n] = Dead[n-1] + StepTime * (ZombiesKillsOnMeatbags + NaturalMeatbagDeaths - RisenDead)*)  
        val new = ( di + (dt *( (a * si * zi) + (d * si) - (z * di) ) ) )
    in
        if (Real.ceil(new) > 0) then (
            RealArray.update(dead, n, new);
            getArrValue(n, dead, "Dead")
        ) else (
            print "\tThere are no dead, yet\n"
        )
    end;

(* tick (n)
 * Takes an Int n that represents the step at which populations are to be calculated.
 * Precondition: if n>0, step n-1 has been calculated and values exist in the respective arrays.
 * Calculates the populations in order Meatbags>Zombies>Dead. Then recursively calls 
 * itself to calculate the next index (n+1) until any one of the following condtitions fails:
 *     1. The Meatbags have not been eradicated. meatbags[n] > 0.
 *     2. The Zombie population has not overshot the total available meatbags.
 *     3. The Simulation is not over. Next step to be executed (n+1) is less than the number of steps (I) in the simulation.
 *)
fun tick n=
(
    print ("Tick: " ^ Int.toString(n+1) ^ "\n");
    meatbagPopTick n;
    zombiePopTick n;
    deadPopTick n;
    print "\n";

    if ((n+1) < i)
        andalso (Real.ceil(RealArray.sub(meatbags, n)) > 0)
        andalso (Real.ceil(RealArray.sub(zombies, n)) <= M)
        then tick (n+1)
    else(
        print "Meatbags: ";
        printArr(0, n, meatbags);
        print "\n";
        print "Zombies: ";
        printArr(0, n, zombies);
        print "\n";
        print "Dead: ";
        printArr(0, n, dead)
    )
)


(*Main*)
fun main ()= 
(
    print "Begining simulation\n";
    let
        val n = 0
    in
        tick n
    end;
    print "Done\n"     
)

(*Run the main function*)
val _ = main ()

