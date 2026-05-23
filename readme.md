# Exit codes are not booleans

The `if` construct in POSIX shell is not a boolean evaluator. It is a command runner that branches on exit status. When you write `if [ condition ]`, you invoke a separate utility, the `[` command, to encode a value as an exit code, which `if` then decodes. the same applies to `[ ] && [ ]` and `[ ] || [ ]` chains, each bracket is a separate command invocation, each one a round trip through a process boundary.

The `case` construct performs no such round trip. It receives a word and dispatches on it directly. No external command, no exit code, no encoding.

This paper argues the choice between `if` and `case` is not stylistic but semantic. The two constructs have different execution models and are not interchangeable.

## License

CC by 4.0 Ivan Gaydardzhiev, 2026
