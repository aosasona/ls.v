module main

import os

const (
	reset = "\033[0m"
	red = "\033[31m"
	cyan = "\033[36m"
	yellow = "\033[33m"
	blue = "\033[34m"
)

struct LS {
	show_hidden bool
	dir string = "."
}

enum FileType {
	dir
	file
	symlink
}

struct FSEntry {
	name string
	file_type FileType
}

fn new_ls(show_hidden bool, other_args []string) &LS {
	return &LS{
		show_hidden: show_hidden,
		dir: other_args[0] or { os.getwd() }
	}
}

fn (ls &LS) dir_exists() bool {
	return os.is_dir(ls.dir)
}

fn (ls &LS) get_files() ![]FSEntry {
	files := os.ls(ls.dir) or { return err }
	mut result := []FSEntry{}
	for file in files {
		if !ls.show_hidden && file[0] == 46 { continue }
		mut entry := FSEntry{ name: file, file_type: ls.get_file_type(file) }
		result << entry // yep, this is very CPP-like, don't know how I feel about it :/
	}

	return result
}

fn (ls &LS) get_file_type(filename string) FileType {
	path := ls.dir + "/" + filename
	if os.is_dir(path) {
		return FileType.dir
	} else if os.is_link(path) {
		return FileType.symlink
	} else {
		return FileType.file
	}
}

fn (ls &LS) print_files(files []FSEntry) {
	for file in files {
		color := match file.file_type {
			.file { "" }
			.dir { cyan }
			.symlink { yellow }
		}
		println('${color}${file.name}${reset}')
	}
}

fn (ls &LS) run()! {
	if !os.is_dir(ls.dir) { return error('`${ls.dir}` is not a directory') }
	if !ls.dir_exists() { return error('directory `${ls.dir}` does not exist') }
	files := ls.get_files() or { return err }
	ls.print_files(files)
	return
}