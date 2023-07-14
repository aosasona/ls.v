module main

import flag
import os

// using the flag module to parse command line arguments, this kind of forces you to use --a instead of -a

fn main() {
	mut fp := flag.new_flag_parser(os.args)

	fp.application("ls")
	fp.limit_free_args(0, 1) or {}
	fp.description("List directory contents")
	fp.skip_executable()

	show_hidden := fp.bool("a", 0, false, "Show hidden files")

	other_args := fp.finalize() or {
		eprintln(err)
		println(fp.usage())
		return
	}

	ls := new_ls(show_hidden, other_args)

	println('ls: ${ls}')
}
