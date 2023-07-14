module main

import os

struct LS {
	show_hidden bool
	dir string = "."
}

fn new_ls(show_hidden bool, other_args []string) &LS {
	return &LS{
		show_hidden: show_hidden,
		dir: other_args[0] or { os.getwd() }
	}
}
