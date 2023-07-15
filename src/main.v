module main

import flag
import os

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application("ls")
	fp.limit_free_args(0, 1) or { printerr(err) }
	fp.description("List directory contents")
	fp.skip_executable()

	show_hidden := fp.bool("a", "a".bytes()[0], false, "Show hidden files")
	other_args := fp.finalize() or {
		printerr(err)
		println("\n"+fp.usage())
		exit(1)
	}

	ls := new_ls(show_hidden, other_args)
	ls.run() or {
		printerr(err)
		exit(1)
	}
}


fn printerr(err IError) {
	println('${red}Error: ${err.msg()}${reset}')
}