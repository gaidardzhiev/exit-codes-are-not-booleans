# Exit Codes Are Not Booleans

There is an idiom so common in POSIX shell that it has stopped being visible. It appears in scripts written by careful people, in codebases maintained by experienced engineers, in tutorials written to teach correct practice. It looks like a conditional. It is not one.

`if [ condition ]` does not evaluate a boolean expression. It runs a command, waits for it to exit, and branches on the exit status. The `[` is not syntax. It is a separate utility whose sole purpose is to encode a value as an exit code so that `if` has something to consume. The value enters as an argument, crosses a process boundary, and returns as a number between zero and one. `if` then decodes that number back into a branch decision. The programmer sees a conditional. The kernel sees a command invocation.

The same error appears in chains. `[ ] && [ ]` and `[ ] || [ ]` are not logical operators over boolean expressions. They are sequencing operators over command exit codes, each `[` a separate invocation, each one the same round trip performed again.

The `case` construct performs none of this. It receives a word, the already expanded result of any shell expression, and dispatches on it directly. No command is run. No exit code is produced or consumed. No process boundary is crossed. It is value dispatch in its native form.

This paper argues that the choice between `if` and `case` is not stylistic but semantic. The two constructs have different execution models and are not interchangeable. When the condition is a command outcome, `if` is correct and irreplaceable. When the condition is a value, `case` is the right primitive, and reaching for `if [ ]` is a category error: a command evaluator applied to a value dispatch problem.

The author ran the following against his own projects before publishing:

```sh
grep -rE --include="*.sh" 'if \[|&&\s*\[|\|\|\s*\[' . | wc -l
```

The result was 2728...

## Files

- `exit_codes_are_not_booleans.pdf` the paper
- `exit_codes_are_not_booleans.tex` latex source

## License

CC by 4.0 Ivan Gaydardzhiev, 2026
