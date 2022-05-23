//[assignment] write your own unit test to show that your Mastermind variation circuit is working as expected

const chai = require("chai");
const path = require("path");

const wasm_tester = require("circom_tester").wasm;

const buildPoseidon = require("circomlibjs").buildPoseidon;

const assert = chai.assert;

describe("Mastermind Bagels test", function () {
    this.timeout(100000000);
    it("Fermi! Fermi! Fermi! Test case", async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        const circuit = await wasm_tester("contracts/circuits/MastermindVariation.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "pubGuessA": "8",
            "pubGuessB": "1",
            "pubGuessC": "4",
            "privSolnA": "8",
            "privSolnB": "1",
            "privSolnC": "4",
            "pubNumFermi": "3",
            "pubNumPico": "0",
            "privSalt": "0",
            "pubSolnHash": F.toObject(poseidon([0,8,1,4]))
        }

        const witness = await circuit.calculateWitness(INPUT, true);

    });

    it("Fermi! Fermi! Bagel! Test case", async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        const circuit = await wasm_tester("contracts/circuits/MastermindVariation.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "pubGuessA": "8",
            "pubGuessB": "1",
            "pubGuessC": "5",
            "privSolnA": "8",
            "privSolnB": "1",
            "privSolnC": "4",
            "pubNumFermi": "2",
            "pubNumPico": "0",
            "privSalt": "0",
            "pubSolnHash": F.toObject(poseidon([0,8,1,4]))
        }

        const witness = await circuit.calculateWitness(INPUT, true);

    });

    it("Pico! Pico! Bagel! Test case", async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        const circuit = await wasm_tester("contracts/circuits/MastermindVariation.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "pubGuessA": "1",
            "pubGuessB": "8",
            "pubGuessC": "5",
            "privSolnA": "8",
            "privSolnB": "1",
            "privSolnC": "4",
            "pubNumFermi": "0",
            "pubNumPico": "2",
            "privSalt": "0",
            "pubSolnHash": F.toObject(poseidon([0,8,1,4]))
        }

        const witness = await circuit.calculateWitness(INPUT, true);

    });

    it("Bagel! Bagel! Bagel! Test case", async () => {
        poseidon = await buildPoseidon();
        F = poseidon.F;
        const circuit = await wasm_tester("contracts/circuits/MastermindVariation.circom");
        await circuit.loadConstraints();

        const INPUT = {
            "pubGuessA": "7",
            "pubGuessB": "2",
            "pubGuessC": "3",
            "privSolnA": "8",
            "privSolnB": "1",
            "privSolnC": "4",
            "pubNumFermi": "0",
            "pubNumPico": "0",
            "privSalt": "0",
            "pubSolnHash": F.toObject(poseidon([0,8,1,4]))
        }

        const witness = await circuit.calculateWitness(INPUT, true);

    });
});
