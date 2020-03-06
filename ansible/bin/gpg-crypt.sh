#!/bin/sh
#
# Decrypt, encrypt and re-encrypt files with GnuPG
#
# Copyright (C) 2018-2019 Libre Space Foundation <https://libre.space/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

usage() {
	cat <<EOF
Usage: $(basename $0) [OPTIONS]...
Options:
  -d                        Decrypt data
  -e <recipient>            Encrypt data for recipient;
                             Can be specified multiple times for multiple
                             recipients
  -r                        Decrypt and encrypt data in one step
  -i <file>                 Use input file instead of standard input
  -o <file>		    Use output file instead of standard output
  --help                    Print usage

EOF
	exit 1
}

parse_args() {
	while [ $# -gt 0 ]; do
		arg="$1"
		case $arg in
			-d)
				if [ -n "$action" ]; then
					usage
				fi
				action="decrypt"
				;;
			-e)
				shift
				if [ -z "$1" ]; then
					usage
				fi
				action="encrypt"
				recipients="$recipients -r $1"
				;;
			-r)
				reencrypt=1
				;;
			-i)
				shift
				if [ -z "$1" ]; then
					usage
				fi
				if [ "$1" != "-" ]; then
					input_file="$1"
				fi
				;;
			-o)
				shift
				if [ -z "$1" ]; then
					usage
				fi
				if [ "$1" != "-" ]; then
					output_file="$1"
				fi
				;;
			*)
				usage
				;;
		esac
		shift
	done
}

main() {
	parse_args $@
	case $action in
		decrypt)
			gpg2 --batch -d -o ${output_file:--}${input_file:+ "$input_file"}
			;;
		encrypt)
			if [ -z "$reencrypt" ]; then
				gpg2 --batch $recipients -a -e -o ${output_file:--}${input_file:+ "$input_file"}
			else
				tmp_dir="$(mktemp -d)"
				if ! gpg2 --batch -d  -o "$tmp_dir/vault-password"${input_file:+ "$input_file"}; then
					exit
				fi
				if [ -f "$output_file" ]; then
					rm "$output_file"
				fi
				if ! gpg2 --batch $recipients -a -e -o ${output_file:--} "$tmp_dir/vault-password"; then
					exit
				fi
				shred -u "$tmp_dir/vault-password"
				rm -r "$tmp_dir"
			fi
			;;
		*)
			usage
			;;
	esac
}

main $@
