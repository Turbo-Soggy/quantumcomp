// 25DC2012 IA3 - Case 21: Simon's Algorithm, s = 11
// Before submitting: rename this file to <YourRegNo>_Case21.qs and
// replace REG_NO_1, REG_NO_2, REG_NO_3 with your team's register numbers.

// Run with Histogram, at least 100 shots. Remove y = 00 and solve y . s = 0 (mod 2) by hand.

operation Main() : Result[] {
    Message("Register numbers: REG_NO_1, REG_NO_2, REG_NO_3");

    use x = Qubit[2];
    use y = Qubit[2];

    // Circuit: H on x[0], x[1] -> oracle -> H on x[0], x[1] -> measure x[0], x[1] to get y
    H(x[0]);
    H(x[1]);

    Oracle(x, y);

    H(x[0]);
    H(x[1]);

    let results = [M(x[0]), M(x[1])];
    Message($"Measured y = {BitString(results)}");

    ResetAll(x + y);
    return results;
}

// f(00) = 00, f(01) = 01, f(10) = 01, f(11) = 00
// Hidden string s = 11, so f(x) = f(x XOR 11). Recipe: CNOT(x[0], y[1]) and CNOT(x[1], y[1])
operation Oracle(x : Qubit[], y : Qubit[]) : Unit {
    CNOT(x[0], y[1]);
    CNOT(x[1], y[1]);
}

// Turns [q[0], q[1], ...] results into a string like "101" (q[0] first).
function BitString(results : Result[]) : String {
    mutable s = "";
    for r in results {
        set s += r == One ? "1" | "0";
    }
    return s;
}
