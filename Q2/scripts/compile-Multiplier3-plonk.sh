#!/bin/bash

cd contracts/circuits

mkdir _plonkMultiplier3

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."

circom Multiplier3.circom --r1cs --wasm --sym -o _plonkMultiplier3
snarkjs r1cs info _plonkMultiplier3/Multiplier3.r1cs

snarkjs plonk setup _plonkMultiplier3/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau _plonkMultiplier3/circuit_final.zkey
echo "{\"a\": 3, \"b\": 2, \"c\": 2}" > _plonkMultiplier3/input.json
cd _plonkMultiplier3/Multiplier3_js
node generate_witness.js Multipler3.wasm ../input.json ../witness.wtns
# snarkjs zkey verify _plonkMultiplier3/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau _plonkMultiplier3/circuit_final.zkey
# snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
# snarkjs plonk prove _plonkMultiplier3/circuit_final.zkey witness.wtns proof.json public.json
# snarkjs plonk verify verification_key.json public.json proof.json
#
# # generate solidity contract
# snarkjs zkey export solidityverifier _plonkMultiplier3/circuit_final.zkey ../_plonkMultiplier3Verifier.sol

cd ../..
