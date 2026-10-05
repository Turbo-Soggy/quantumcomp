// 25DC2012 IA3 - Case 16: Grover's Search Algorithm, marked item |01>
// Before submitting: rename this file to <YourRegNo>_Case16.qs and
// replace REG_NO_1, REG_NO_2, REG_NO_3 with your team's register numbers.

// Run with Histogram, at least 100 shots. Then change iterations to 2 and run again.

operation Main() : Result[] {
    Message("Register numbers: REG_NO_1, REG_NO_2, REG_NO_3");

    let iterations = 1; // change to 2 for the second run

    use q = Qubit[2];

    // Circuit: H on both -> (oracle -> diffusion) x iterations -> measure both
    H(q[0]);
    H(q[1]);

    for _ in 1..iterations {
        Oracle(q);
        Diffusion(q);
    }

    let results = [M(q[0]), M(q[1])];
    Message($"Iterations = {iterations}, measured {BitString(results)}");

    ResetAll(q);
    return results;
}

// Marks |01> (q[0] q[1]) by flipping its phase: X on q[0] -> CZ(q[0], q[1]) -> X on q[0]
operation Oracle(q : Qubit[]) : Unit {
    X(q[0]);
    CZ(q[0], q[1]);
    X(q[0]);
}

// Diffusion: H on both -> X on both -> CZ(q[0], q[1]) -> X on both -> H on both
operation Diffusion(q : Qubit[]) : Unit {
    H(q[0]);
    H(q[1]);
    X(q[0]);
    X(q[1]);
    CZ(q[0], q[1]);
    X(q[0]);
    X(q[1]);
    H(q[0]);
    H(q[1]);
}

// Turns [q[0], q[1], ...] results into a string like "101" (q[0] first).
function BitString(results : Result[]) : String {
    mutable s = "";
    for r in results {
        set s += r == One ? "1" | "0";
    }
    return s;
}
