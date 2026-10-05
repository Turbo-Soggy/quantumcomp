# 25DC2012 IA3 – Quantum Algorithms in Q#

One Q# program for each of the 25 cases in the IA3 handout, in [`cases/`](cases/).
Every program follows its case's circuit recipe exactly, keeps the oracle in its own
operation, and prints the team's register numbers first using `Message()`.

## Before you submit

1. Find out your team's case number from your teacher or Google Classroom.
2. Open `cases/RegNo_CaseNN.qs` for that case.
3. Replace `REG_NO_1, REG_NO_2, REG_NO_3` on the `Message(...)` line with your real register numbers.
4. Rename the file to `<YourRegNo>_CaseNN.qs`, for example `URK23CS1234_Case07.qs`.
5. Open the file in VS Code with the Quantum Development Kit extension, then click **Run** (cases 1–8) or **Histogram** (cases 9–25).
6. Take screenshots of the code, the output and the histogram for the report.
7. **Make sure every team member understands the code.** The rubric gives 0–3 for implementation if you can't explain it.

## Expected results

All 25 programs were tested in the Q# simulator. In the results, bits are printed in the order q[0], q[1], ….

| Case | Algorithm | Variant | Expected output |
|---|---|---|---|
| 1 | Deutsch | f(x) = x | f: **1 → balanced**; f(x)=0: 0 → constant |
| 2 | Deutsch | f(x) = NOT x | f: **1 → balanced**; f(x)=0: 0 → constant |
| 3 | Deutsch | f(x) = 1 | f: **0 → constant**; f(x)=0: 0 → constant |
| 4 | Deutsch–Jozsa | x0 ⊕ 1 | f: **100 → balanced**; f=1: 000 → constant |
| 5 | Deutsch–Jozsa | x0 ⊕ x1 ⊕ 1 | f: **110 → balanced**; f=1: 000 → constant |
| 6 | Deutsch–Jozsa | x1 ⊕ x2 ⊕ 1 | f: **011 → balanced**; f=1: 000 → constant |
| 7 | Deutsch–Jozsa | x0 ⊕ x2 ⊕ 1 | f: **101 → balanced**; f=1: 000 → constant |
| 8 | Deutsch–Jozsa | x0 ⊕ x1 ⊕ x2 ⊕ 1 | f: **111 → balanced**; f=1: 000 → constant |
| 9–14 | Bernstein–Vazirani | s = 001 … 110 | 100% of shots give exactly **s** |
| 15–18 | Grover | marked 00 / 01 / 10 / 11 | 1 iteration: 100% the **marked item**. 2 iterations: about 25% for each of the four results |
| 19 | Simon | s = 01 | about 50% **00**, 50% **10** |
| 20 | Simon | s = 10 | about 50% **00**, 50% **01** |
| 21 | Simon | s = 11 | about 50% **00**, 50% **11** |
| 22–25 | Shor | N = 15, a = 2 / 7 / 8 / 13 | about 25% each of c = 000, 010, 001, 011, which give **y = 0, 2, 4, 6** |

## Notes for the report questions (Q1, Q2)

These notes explain the ideas behind each answer. The rubric marks Part B for being in
**your own words**, so use them to understand the ideas, then write your answers yourself.

### Deutsch (cases 1–3)
- **Q1 – Phase kickback.** X then H puts the ancilla in |−⟩ = (|0⟩ − |1⟩)/√2. The oracle does |x⟩|y⟩ → |x⟩|y ⊕ f(x)⟩.
  If f(x) = 1, the ancilla flips from |−⟩ to −|−⟩. The ancilla itself doesn't change, but a phase (−1)^f(x) is
  "kicked back" onto |x⟩. That turns the input into (−1)^f(0)|0⟩ + (−1)^f(1)|1⟩. The last H then sends it to
  |0⟩ when f(0) = f(1) (constant) or |1⟩ when f(0) ≠ f(1) (balanced). Without |−⟩ there would be no phase to read.
- **Q2.** A classical computer needs **2** calls, f(0) and f(1). The quantum circuit uses **1**.

### Deutsch–Jozsa (cases 4–8)
- **Q1.** After the final H gates, the amplitude of |000⟩ is (1/8) Σₓ (−1)^f(x).
  If f is constant, every term has the same sign, so the amplitude is ±1 and you always measure 000.
  If f is balanced, four terms are +1 and four are −1, so the amplitude is 0 and you never measure 000.
- **Q2.** A classical computer needs 2³⁻¹ + 1 = **5** calls in the worst case: 4 equal answers could still come from
  a balanced function, so a 5th call is needed. The quantum circuit uses **1**.
- In these cases the output is the set of xi that appear in f. That's why x0 ⊕ x2 ⊕ 1 gives 101: the "⊕ 1" only adds a global phase.

### Bernstein–Vazirani (cases 9–14)
- **Q1.** Phase kickback gives the state (1/√8) Σₓ (−1)^(s·x) |x⟩. This is exactly H⊗³|s⟩, and H is its own inverse,
  so the final H gates return |s⟩ with certainty. That's why 100% of shots show s.
- **Q2.** A classical computer needs **3** calls, querying x = 100, 010 and 001 to read one bit each. The quantum circuit uses **1**.

### Grover (cases 15–18)
- **Q1.** k = ⌊(π/4)√4⌋ = ⌊π/2⌋ = ⌊1.57⌋ = **1**. With N = 4, the starting state makes an angle of θ/2 = 30° with the
  unmarked states. Each iteration rotates it 60° towards the marked item. After 1 iteration the angle is 90°, so you
  find the marked item 100% of the time. After 2 iterations it is 150°, which overshoots: sin²150° = 0.25, so the
  histogram becomes roughly uniform at about 25% each.
- **Q2.** The oracle flips the sign (phase) of the marked item only. The diffusion operator reflects every amplitude
  about the average ("inversion about the mean"). This boosts the marked item, whose amplitude is now negative and
  far below the average, and shrinks the others.

### Simon (cases 19–21)
- **Q1.** Each measured y satisfies y·s = 0 (mod 2). For example, in case 19, y = 10 gives 1·s0 + 0·s1 = 0, so s0 = 0.
  Since s ≠ 00, s = **01**. In case 20, y = 01 gives s1 = 0, so s = **10**. In case 21, y = 11 gives s0 + s1 = 0, so s0 = s1, and s = **11**.
- **Q2.** y = 00 gives 0·s0 + 0·s1 = 0, which is true for **every** s. It rules nothing out.

### Shor (cases 22–25)
- **Q1.** The histogram shows y ∈ {0, 2, 4, 6}, so y/8 ∈ {0, 1/4, 1/2, 3/4} = k/4, and the period is **r = 4**.
  r is even, so compute gcd(a^(r/2) ± 1, 15):
  - a = 2: 2² = 4 → gcd(3, 15) = **3**, gcd(5, 15) = **5**
  - a = 7: 7² = 49 → gcd(48, 15) = **3**, gcd(50, 15) = **5**
  - a = 8: 8² = 64 → gcd(63, 15) = **3**, gcd(65, 15) = **5**
  - a = 13: 13² = 169 → gcd(168, 15) = **3**, gcd(170, 15) = **5**

  So 15 = 3 × 5. (y = 0 gives no information. y = 4 gives 1/2, which on its own suggests r = 2, but a² mod 15 = 4 ≠ 1, so r = 2 is wrong. Use y = 2 or 6.)
- **Q2.** c[2] would control multiplication by a^(2²) = a⁴ mod 15. Since a⁴ mod 15 = 1, that operation is
  "multiply by 1", which is the identity. It changes nothing, so no gate is needed.
