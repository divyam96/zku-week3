pragma circom 2.0.0;

// [assignment] implement a variation of mastermind from https://en.wikipedia.org/wiki/Mastermind_(board_game)#Variation as a circuit

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";


template MastermindVariation() {

//Implementing Bagels

// Public inputs
signal input pubGuessA;
signal input pubGuessB;
signal input pubGuessC;
signal input pubNumFermi;
signal input pubNumPico;
signal input pubSolnHash;

// Private inputs
signal input privSolnA;
signal input privSolnB;
signal input privSolnC;
signal input privSalt;

// Output
signal output solnHashOut;

var guess[3] = [pubGuessA, pubGuessB, pubGuessC];
var soln[3] =  [privSolnA, privSolnB, privSolnC];
var j = 0;
var k = 0;
component lessThan[6];
component equalGuess[3];
component equalSoln[3];
var equalIdx = 0;

// Create a constraint that the solution and guess digits are all less than 10.
for (j=0; j<3; j++) {
    lessThan[j] = LessThan(4);
    lessThan[j].in[0] <== guess[j];
    lessThan[j].in[1] <== 10;
    lessThan[j].out === 1;
    lessThan[j+3] = LessThan(4);
    lessThan[j+3].in[0] <== soln[j];
    lessThan[j+3].in[1] <== 10;
    lessThan[j+3].out === 1;
    for (k=j+1; k<3; k++) {
        // Create a constraint that the solution and guess digits are unique. no duplication.
        equalGuess[equalIdx] = IsEqual();
        equalGuess[equalIdx].in[0] <== guess[j];
        equalGuess[equalIdx].in[1] <== guess[k];
        equalGuess[equalIdx].out === 0;
        equalSoln[equalIdx] = IsEqual();
        equalSoln[equalIdx].in[0] <== soln[j];
        equalSoln[equalIdx].in[1] <== soln[k];
        equalSoln[equalIdx].out === 0;
        equalIdx += 1;
    }
}

// Count fermi & pico
var fermi = 0;
var pico = 0;
component equalHB[9];

for (j=0; j<3; j++) {
    for (k=0; k<3; k++) {
        equalHB[3*j+k] = IsEqual();
        equalHB[3*j+k].in[0] <== soln[j];
        equalHB[3*j+k].in[1] <== guess[k];
        pico += equalHB[3*j+k].out;
        if (j == k) {
            fermi += equalHB[3*j+k].out;
            pico -= equalHB[3*j+k].out;
        }
    }
}

// Create a constraint around the number of fermi
component equalFermi = IsEqual();
equalFermi.in[0] <== pubNumFermi;
equalFermi.in[1] <== fermi;
equalFermi.out === 1;

// Create a constraint around the number of pico
component equalPico = IsEqual();
equalPico.in[0] <== pubNumPico;
equalPico.in[1] <== pico;
equalPico.out === 1;

// Verify that the hash of the private solution matches pubSolnHash
component poseidon = Poseidon(4);
poseidon.inputs[0] <== privSalt;
poseidon.inputs[1] <== privSolnA;
poseidon.inputs[2] <== privSolnB;
poseidon.inputs[3] <== privSolnC;

solnHashOut <== poseidon.out;
pubSolnHash === solnHashOut;
}

component main = MastermindVariation();
