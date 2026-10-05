// 25DC2012 IA3 - Case 10: Bernstein-Vazirani Algorithm, s = 010
// Before submitting: rename this file to <YourRegNo>_Case10.qs and
// replace REG_NO_1, REG_NO_2, REG_NO_3 with your team's register numbers.

// Run with Histogram, at least 100 shots. Every shot should give 010.

operation Main() : Result[] {
    Message("Register numbers: REG_NO_1, REG_NO_2, REG_NO_3");

    use q = Qubit[3];
    use y = Qubit();

    // Circuit: X(y) -> H on all 4 qubits -> oracle -> H on q[0], q[1], q[2] -> measure q
    X(y);
    for i in 0..2 {
        H(q[i]);
    }
    H(y);

    Oracle(q, y);

    for i in 0..2 {
        H(q[i]);
    }

    let results = [M(q[0]), M(q[1]), M(q[2])];
    Message($"Measured s = {BitString(results)}");

    ResetAll(q + [y]);
    return results;
}

// Hidden string s = 010 (s0 s1 s2 matching q[0] q[1] q[2]).
// f(x) = s . x (mod 2): one CNOT from each q[i] with si = 1 -> CNOT(q[1], y)
operation Oracle(q : Qubit[], y : Qubit) : Unit {
    CNOT(q[1], y);
}

// Turns [q[0], q[1], ...] results into a string like "101" (q[0] first).
function BitString(results : Result[]) : String {
    mutable s = "";
    for r in results {
        set s += r == One ? "1" | "0";
    }
    return s;
}
