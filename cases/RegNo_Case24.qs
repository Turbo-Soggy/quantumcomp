// 25DC2012 IA3 - Case 24: Shor's Factoring Algorithm, N = 15, a = 8
// Before submitting: rename this file to <YourRegNo>_Case24.qs and
// replace REG_NO_1, REG_NO_2, REG_NO_3 with your team's register numbers.

// Run with Histogram, at least 200 shots. Convert results to y = c[0] + 2*c[1] + 4*c[2],
// find the period r from y / 8 ~ k / r, then compute the factors with gcd.
// Powers of 8 mod 15: 8^1 = 8, 8^2 = 4, 8^3 = 2, 8^4 = 1

operation Main() : Result[] {
    Message("Register numbers: REG_NO_1, REG_NO_2, REG_NO_3");

    use c = Qubit[3]; // counting qubits
    use w = Qubit[4]; // work qubits, w[0] is the lowest bit

    // Start the work register at 1
    X(w[0]);

    // H on all counting qubits
    for i in 0..2 {
        H(c[i]);
    }

    // Controlled modular multiplications
    MultiplyBy8Mod15(c[0], w);
    MultiplyBy4Mod15(c[1], w); // 8^2 mod 15 = 4
    // 8^4 mod 15 = 1, so nothing is needed for c[2]

    InverseQFT(c);

    let results = [M(c[0]), M(c[1]), M(c[2])];
    let y = (results[0] == One ? 1 | 0) + 2 * (results[1] == One ? 1 | 0) + 4 * (results[2] == One ? 1 | 0);
    Message($"Measured c = {BitString(results)} -> y = {y}");

    ResetAll(c + w);
    return results;
}

// Multiply-by-8 (mod 15), controlled by c
operation MultiplyBy8Mod15(c : Qubit, w : Qubit[]) : Unit {
    Controlled SWAP([c], (w[0], w[1]));
    Controlled SWAP([c], (w[1], w[2]));
    Controlled SWAP([c], (w[2], w[3]));
}

// Multiply-by-4 (mod 15), controlled by c
operation MultiplyBy4Mod15(c : Qubit, w : Qubit[]) : Unit {
    Controlled SWAP([c], (w[1], w[3]));
    Controlled SWAP([c], (w[0], w[2]));
}

// Inverse QFT on 3 qubits:
// SWAP(c[0], c[2]) -> H(c[0]) -> controlled R1(-pi/2) from c[0] to c[1] -> H(c[1])
// -> controlled R1(-pi/4) from c[0] to c[2] -> controlled R1(-pi/2) from c[1] to c[2] -> H(c[2])
operation InverseQFT(c : Qubit[]) : Unit {
    SWAP(c[0], c[2]);
    H(c[0]);
    Controlled R1([c[0]], (-Std.Math.PI() / 2.0, c[1]));
    H(c[1]);
    Controlled R1([c[0]], (-Std.Math.PI() / 4.0, c[2]));
    Controlled R1([c[1]], (-Std.Math.PI() / 2.0, c[2]));
    H(c[2]);
}

// Turns [q[0], q[1], ...] results into a string like "101" (q[0] first).
function BitString(results : Result[]) : String {
    mutable s = "";
    for r in results {
        set s += r == One ? "1" | "0";
    }
    return s;
}
