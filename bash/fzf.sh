#!/bin/bash

#cd using fzf
fd() {
	local search_term 
	local find_options=('--type=d' '--absolute-path' '--follow' '.')
	while [[ $# -gt 0	]]; do
		key="$1"
		case $key in
			-a|--all) #-a or --all to search for hidden directories as well
				shift
				find_options=("${find_options[@]}" '--hidden' '--no-ignore')
				;;
			-d|--depth) # depth of traversal
				shift
				key="$1"
				shift
				find_options=("${find_options[@]}" "-d $key")
				;;
			*)
				search_term=$key
				shift
				;;
		esac
	done

	if [ -z "$search_term" ]; then
		echo "No search term provided"
		return 1
	fi

	local dir
	local fzf_options=('+m' '--algo=v1' '-1')

	dir=$(fnd ${find_options[*]} "$search_term" | fzf-tmux ${fzf_options[*]})

	if [ -n "$dir" ]; then
		cd -P "$dir"

		if [ -f ".nvmrc" ]; then
			nvm use --silent 1>/dev/null
		fi
	fi
}

#open something in vim using fzf
#optional arguments to specify something to search for (e.g. using rg to grep something then vim-ing the file)
fvim() {
	local directory file_search search_term
	while [[ $# -gt 0	]]; do
		local key
		key="$1"
		case $key in
			-d|--directory)
				shift
				directory="$1"
				;;
			-f|--file)
				shift
				file_search=true
				;;
			*)
				search_term=$key
				shift
				;;
		esac
	done

	local file
	directory=${directory:-.}
	if [ -z $search_term ]; then
		search_term="."
		file_search=true
	fi

	if [[ $file_search ]]; then
		file="$(fnd --hidden --follow --exclude "*.git/" "$search_term" "$directory" | fzf-tmux -m --ansi -0 -1)"
	else
		file="$(cd -P "$directory"; rg "$search_term" | fzf-tmux -m --ansi -0 -1 | awk -F: '{print $1 " +" $2}')"
	fi

	if [[ -n $file ]]; then
		vim "$file"
	fi
}

#fuzzy branch finding
fbr() {
	local branches branch
	branches=$(git branch --all | grep -v HEAD)
	branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m)
	git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

#fuzzy comamnd searching
#FIXME: this isn't working at all right now
commands() {
	compgen -c | fzf
}
