#!/usr/bin/env bash
#
# installs things.
# adapted from https://github.com/holman/dotfiles

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

set -eu

echo ''

info () {
	printf "	[ \033[00;34m..\033[0m ] %s" "$1"
}

user () {
	printf "\r	[ \033[0;33m?\033[0m ] %s" "$1"
}

success () {
	printf "\r\033[2K	[ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
	printf "\r\033[2K	[\033[0;31mFAIL\033[0m] %s\n" "$1"
	echo ''
	exit
}

link_file () {
	local src=$1
	local action backup dst overwrite skip
	action=
	backup=
	overwrite=
	skip=
	dst="$HOME/.$(basename "$1" ".symlink")"

	if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
	then

		if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
		then
			local currentSrc
			currentSrc="$(readlink "$dst")"

			if [ "$currentSrc" == "$src" ]
			then
				skip=true;
			else
				user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
				[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
				read -rn 1 action

				case "$action" in
					o )
						overwrite=true;;
					O )
						overwrite_all=true;;
					b )
						backup=true;;
					B )
						backup_all=true;;
					s )
						skip=true;;
					S )
						skip_all=true;;
					* )
						;;
				esac
			fi
		fi

		overwrite=${overwrite:-$overwrite_all}
		backup=${backup:-$backup_all}
		skip=${skip:-$skip_all}

		if [ "$overwrite" == "true" ]
		then
			rm -rf "$dst"
			success "removed $dst"
		fi

		if [ "$backup" == "true" ]
		then
			mv "$dst" "${dst}.backup"
			success "moved $dst to ${dst}.backup"
		fi

		if [ "$skip" == "true" ]
		then
			success "skipped $src"
		fi
	fi

	if [ "$skip" != "true" ]	# "false" or empty
	then
		ln -s "$src" "$dst"
		success "linked $src to $dst"
	fi
}

install_dotfiles () {
	info "installing dotfiles from $DOTFILES_ROOT"

	local overwrite_all=false backup_all=false skip_all=false

	# export -f link_file user success fail;
	# find "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -exec bash -ci 'link_file "$0"' {} \;
	for src in $(find "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink')
	do
		link_file "$src"
	done
}

install_dotfiles

echo ''
echo '	All installed!'
