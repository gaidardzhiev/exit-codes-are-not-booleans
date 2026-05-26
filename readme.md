# Exit Codes Are Not Booleans

There is an idiom so common in POSIX shell that it has stopped being visible. It appears in scripts written by careful people, in codebases maintained by experienced engineers, in tutorials written to teach correct practice. It looks like a conditional. It is not one.

`if [ condition ]` does not evaluate a boolean expression. It runs a command, waits for it to exit, and branches on the exit status. The `[` is not syntax. It is a separate utility whose sole purpose is to encode a value as an exit code so that `if` has something to consume. The value enters as an argument, crosses a process boundary, and returns as a number between zero and one. `if` then decodes that number back into a branch decision. The programmer sees a conditional. The kernel sees a command invocation.

The same error appears in chains. `[ ] && [ ]` and `[ ] || [ ]` are not logical operators over boolean expressions. They are sequencing operators over command exit codes, each `[` a separate invocation, each one the same round trip performed again.

The `case` construct performs none of this. It receives a word, the already expanded result of any shell expression, and dispatches on it directly. No command is run. No exit code is produced or consumed. No process boundary is crossed. It is value dispatch in its native form.

This paper argues that the choice between `if` and `case` is not stylistic but semantic. The two constructs have different execution models and are not interchangeable. When the condition is a command outcome, `if` is correct and irreplaceable. When the condition is a value, `case` is the right primitive, and reaching for `if [ ]` is a category error: a command evaluator applied to a value dispatch problem.

The author performed a ritual inventory of his own sins, running the following audit against his projects before publishing:

```sh
grep -rE --include="*.sh" 'if \[|&&\s*\[|\|\|\s*\[' . | wc -l
```

The result was 2728. If there is absolution here, it is earned only through exposure, and an embarrassed, stubborn commitment to fix what I so confidently decried. Consider this your warning, my mea culpa, and my invitation: scrutinize loudly, refactor mercilessly.

## Files

- [exit_codes_are_not_booleans.pdf](./exit_codes_are_not_booleans.pdf) the paper
- [exit_codes_are_not_booleans.tex](./exit_codes_are_not_booleans.tex) latex source
- [compare.sh](./compare.sh) a POSIX shell benchmark written in 2025, a year before the paper it corroborates
- [tex2pdf.sh](./tex2pdf.sh) an interactive POSIX shell utility that prompts to build the LaTeX source into a PDF using either xelatex or pdflatex, and copies the result to ~/Downloads
- [ecnb_empirical.pdf](./ecnb_empirical.pdf) the empirical companion paper
- [ecnb_empirical.tex](./ecnb_empirical.tex) latex source

## The Benchmark

[compare.sh](./compare.sh) was excluded from the main paper deliberately. The central argument is semantic, not empirical, and a benchmark cited in its support would have invited the wrong refutation, an optimised implementation, a faster machine, a narrower margin, none of which would touch the structural claim. The script exists because the performance consequence of a category error is still a consequence, and because a reader who finds the theoretical argument unconvincing deserves the opportunity to time it themselves.

Both functions compute `r=$((i % 6))` once per iteration. The arithmetic is identical. The only variable is the dispatch mechanism: `if` routes through `[ ]` and exit codes; `case` dispatches on the value directly.

## The Empirical Paper

[ecnb_empirical.pdf](./ecnb_empirical.pdf) is a companion to the semantic argument. It measures what the first paper declines to do: the cost of the round trip, in nanoseconds, across three shell configurations on an ARM Cortex A53 running 32-bit Arch Linux. The result is consistent across every shell tested. `case` outperforms `if`/`[` by factors of 2.33x, 2.35x, and 3.09x. The most significant finding is directional: the faster the shell implementation, the larger the relative overhead. Optimising the shell does not close the gap. It widens it.

## License

The papers are released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) by Ivan Gaydardzhiev, 2026.

The software in this repository is released under [GPL-3.0-only](./COPYING).
