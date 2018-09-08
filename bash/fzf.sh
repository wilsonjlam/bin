#!/bin/bash

#cd using fzf
fd() {
	local search_term ALL
	while [[ $# -gt 0	]]; do
		key="$1"
		case $key in
			-a|--all) #-a or --all to search for hidden directories as well
				shift
				ALL=true
				;;
			*)
				search_term=$key
				shift
				;;
		esac
	done

	local dir
	local find_options=('--type=d' '--absolute-path' '--follow' '.')
	local fzf_options=('+m' '--algo=v1' '-1')

	if [ -z $search_term ]; then
		dir=$(ls $HOME/workspace | fzf-tmux ${fzf_options[*]})
		dir=${dir:+$HOME/workspace/$dir}
	elif [ $ALL ]; then
		# dir=$(find "$search_term" -type d 2> /dev/null | fzf +m --algo=v1)
		dir=$(fnd ${find_options[*]} --hidden --no-ignore "$search_term" | fzf-tmux ${fzf_options[*]})
	else
		# dir=$(find "$search_term" -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m --algo=v1)
		dir=$(fnd ${find_options[*]} "$search_term" | fzf-tmux ${fzf_options[*]})
	fi

	if [ -n "$dir" ]; then
		cd -P "$dir"
	fi
}

#open something in vim using fzf
#optional arguments to specify something to search for (e.g. using rg to grep something then vim-ing the file)
fvim() {
	local directory edit file_search search_term
	while [[ $# -gt 0	]]; do
		local key
		key="$1"
		case $key in
			-d|--directory)
				shift
				directory="$1"
				;;
			-e|--edit) #-a or --all to search for hidden directories as well
				shift
				edit=true
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
		file="$(fnd --hidden --follow --exclude "*.git/" "$search_term" "$directory" | fzf-tmux --ansi -0 -1)"
	else
		file="$(cd -P "$directory"; rg "$search_term" | fzf-tmux --ansi -0 -1 | awk -F: '{print $1 " +" $2}')"
	fi

	if [[ -n $file ]]; then
		if [ $EDIT ]; then
			mvim $file
		else
			nvim $file
		fi
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
