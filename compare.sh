#!/bin/sh
#this script benchmarks the execution time of 'if' and 'case' statements in a POSIX shell
#the arithmetic λόγος employed in ftestif() and ftestcase() is strictly identical
#both functions compute r=$((i % 6)) once per iteration and dispatch on that single value
#the only variable is the dispatch mechanism: 'if' routes through [ ] and exit codes; 'case' dispatches on the value directly
#Copyright (C) 2025 Ivan Gaydardzhiev
#Licensed under the GPL-3.0-only

ftestif() {
	start=$(date +%s%N)
	for i in $(seq 1 100000);
	do
		r=$((i % 6))
		if [ "$r" -eq 0 ]; then
			result="even and divisible by three"
		elif [ "$r" -eq 2 ] || [ "$r" -eq 4 ]; then
			result="even"
		elif [ "$r" -eq 3 ]; then
			result="divisible by three"
		else
			result="odd"
		fi
	done
	end=$(date +%s%N)
	elapsed=$((end - start))
	printf "'if'   statements execution time: $elapsed nanoseconds\n"
}

ftestcase() {
	start=$(date +%s%N)
	for i in $(seq 1 100000);
	do
		r=$((i % 6))
		case $r in
			0)
				result="even and divisible by three"
				;;
			2|4)
				result="even"
				;;
			3)
				result="divisible by three"
				;;
			*)
				result="odd"
				;;
		esac
	done
	end=$(date +%s%N)
	elapsed=$((end - start))
	printf "'case' statements execution time: $elapsed nanoseconds\n"
}

flogos() {
	sed -n '2s/^.\(.*\)/\1/p' "$0"
	sed -n '3s/^.\(.*\)/\1/p' "$0"
	sed -n '4s/^.\(.*\)/\1/p' "$0"
	sed -n '5s/^.\(.*\)/\1/p' "$0"
	sed -n '6s/^.\(.*\)/\1/p' "$0"
	sed -n '7s/^.\(.*\)/\1/p' "$0"
	printf "\n"
}

flogos
p=$(ftestif) && printf "$p\n"
q=$(ftestcase) && printf "$q\n"

z=$(printf "$p" | sed -n 's/[^0-9]*\([0-9]*\).*/\1/p')
x=$(printf "$q" | sed -n 's/[^0-9]*\([0-9]*\).*/\1/p')

f=$( [ "$z" -lt "$x" ] && printf "'if' is faster by $((x - z)) nanoseconds" || printf "'case' is faster by  $((z - x)) nanoseconds" )

printf "\nin this test %s\n" "$f"
