// 25DC2012 IA3 - Case 04: Deutsch-Jozsa Algorithm, f = x0 XOR 1
// Before submitting: rename this file to <YourRegNo>_Case04.qs and
// replace REG_NO_1, REG_NO_2, REG_NO_3 with your team's register numbers.

operation Main() : (Result[], Result[]) {
    Message("Register numbers: REG_NO_1, REG_NO_2, REG_NO_3");

    // Run 1: our function f = x0 XOR 1 (balanced)
    let mine = RunDeutschJozsa(OracleMine);
    Message($"f = x0 XOR 1 : measured {BitString(mine)} -> {Verdict(mine)}");

    // Run 2: comparison function f = 1 (constant)
    let comparison = RunDeutschJozsa(OracleOne);
    Message($"f = 1 : measured {BitString(comparison)} -> {Verdict(comparison)}");

    return (mine, comparison);
}

// Oracle for f = x0 XOR 1: CNOT(q[0], y), then X(y)
operation OracleMine(q : Qubit[], y : Qubit) : Unit {
    CNOT(q[0], y);
    X(y);
}

// Oracle for f = 1: X(y) only
operation OracleOne(q : Qubit[], y : Qubit) : Unit {
    X(y);
}

// Circuit: X(y) -> H on all 4 qubits -> oracle -> H on q[0], q[1], q[2] -> measure q
operation RunDeutschJozsa(oracle : ((Qubit[], Qubit) => Unit)) : Result[] {
    use q = Qubit[3];
    use y = Qubit();

    X(y);
    for i in 0..2 {
        H(q[i]);
    }
    H(y);

    oracle(q, y);

    for i in 0..2 {
        H(q[i]);
    }

    let results = [M(q[0]), M(q[1]), M(q[2])];
    ResetAll(q + [y]);
    return results;
}

// 000 = constant, anything else = balanced
function Verdict(results : Result[]) : String {
    return BitString(results) == "000" ? "constant" | "balanced";
}

// Turns [q[0], q[1], ...] results into a string like "101" (q[0] first).
function BitString(results : Result[]) : String {
    mutable s = "";
    for r in results {
        set s += r == One ? "1" | "0";
    }
    return s;
}
