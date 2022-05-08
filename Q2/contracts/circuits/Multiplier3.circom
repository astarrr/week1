pragma circom 2.0.0;


template Multiplier3 () {

   // Declaration of signals.
   signal input a;
   signal input b;
   signal input c;
   signal output d;
   signal output e;

   // Constraints.
   d <== a * b;
   e <== d * c;
}

component main = Multiplier3();
