#!/bin/bash

#cd using fzf
fd() {
  while [[ $# -gt 0  ]]; do
    local key
    key="$1"
    case $key in
      -a|--all) #-a or --all to search for hidden directories as well
	shift
	ALL=true
	;;
    esac
  done

  local dir
  if [ ALL ]; then
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m)
  else
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m)
  fi
  cd "$dir"
}

#open something in vim using fzf
#optional arguments to specify something to search for (e.g. using rg to grep something then vim-ing the file)
fvim() {
  local file

  if [ $# -eq 0 ]; then
    file=$(fzf)
  else
    file="$(rg --pretty -n --no-heading $@ | fzf --ansi -0 -1 | awk -F: '{print $1 " +" $2}')"
  fi

  if [[ -n $file ]]
  then
     vim $file
  fi
}

#fuzzy branch finding
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

