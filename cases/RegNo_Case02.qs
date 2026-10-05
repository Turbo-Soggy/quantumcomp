// 25DC2012 IA3 - Case 02: Deutsch's Algorithm, f(x) = NOT x
// Before submitting: rename this file to <YourRegNo>_Case02.qs and
// replace REG_NO_1, REG_NO_2, REG_NO_3 with your team's register numbers.

operation Main() : (Result, Result) {
    Message("Register numbers: REG_NO_1, REG_NO_2, REG_NO_3");

    // Run 1: our function f(x) = NOT x
    let mine = RunDeutsch(OracleMine);
    Message($"f(x) = NOT x : measured x = {mine} -> {Verdict(mine)}");

    // Run 2: comparison function f(x) = 0
    let comparison = RunDeutsch(OracleZero);
    Message($"f(x) = 0 : measured x = {comparison} -> {Verdict(comparison)}");

    return (mine, comparison);
}

// Oracle for f(x) = NOT x: CNOT(x, y) then X(y)
operation OracleMine(x : Qubit, y : Qubit) : Unit {
    CNOT(x, y);
    X(y);
}

// Oracle for f(x) = 0: no gate
operation OracleZero(x : Qubit, y : Qubit) : Unit {
}

// Circuit: X(y) -> H on x and y -> oracle -> H(x) -> measure x
operation RunDeutsch(oracle : ((Qubit, Qubit) => Unit)) : Result {
    use x = Qubit();
    use y = Qubit();

    X(y);
    H(x);
    H(y);
    oracle(x, y);
    H(x);

    let result = M(x);
    ResetAll([x, y]);
    return result;
}

// 0 = constant, 1 = balanced
function Verdict(r : Result) : String {
    return r == Zero ? "constant" | "balanced";
}
