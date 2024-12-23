#!/bin/sh
##############################################################################
export WINEPREFIX=${HOME}/.wine-pyinstaller
##############################################################################
# Directories
##############################################################################
py_file="${1}"
bin_name="$(basename ${py_file} .py)"
script_dir="$(dirname $(readlink -f $0))"
base_dir="$(dirname "$script_dir")"
build_dir="${base_dir}/build"
dist_dir="${base_dir}/dist"
bin_dir="${base_dir}/bin"
##############################################################################
# Functions
##############################################################################
do_clean () {
	rm -rf "$build_dir" "$dist_dir" "${bin_name}.spec"
}

build_win () {
	wine pyinstaller.exe --onefile -w "${py_file}"
	mv "${dist_dir}/${bin_name}.exe" "${bin_dir}/windows"
	do_clean
}

build_linux () {
	pyinstaller --onefile -w "${py_file}"
	mv "${dist_dir}/${bin_name}" "${bin_dir}/linux"
	do_clean
}

cd "$base_dir" || exit

build_win

build_linux
