#!/bin/bash
set -euo pipefail

if [ -n "$WORKSPACE" ]; then
	echo "Please set the $WORKSPACE enviornment variable"
fi

declare -a failedRepos

handleFailure() {
	echo "$BASH_COMMAND" failed with status $?
	failedRepos+=("$(pwd | rev | cut -d '/' -f 1 | rev)")
}
trap handleFailure ERR

dryrun=""

if [[ "$dryrun" ]]; then
	echo "Test catching failure y/n?"
	read -r testFailure
	failCode=11
	fail() {
		return $failCode
	}

	testFail() {
		if [ "$testFailure" == "y" ]; then
			fail
			retval=$?
			if [ $retval -ne 0 ]; then
				echo >&2 "ERROR: Failed with status $retval"
				exit 1
			fi
		fi
	}
fi

function updateRepo () {
	if [ ! -d "$directory" ] || [ ! -d "$directory"/.git ]; then
		echo "Skipping ${directory} since it's not a repo"
		return
	fi

	cd -P "$directory"
	echo -e "\\nCurrently in ${directory}"
	dirty=0
	current_branch="$(git symbolic-ref --short HEAD)"
	echo -e "On branch ${current_branch}\\n"
	if [  -n "$(git status --short -uno 2> /dev/null | tail -n1)" ]; then
		dirty=1
		if [ "$dryrun" ]; then
			echo "Branch is dirty"
			echo "git stash"
			testFail
		else
			echo "Stashing"
			git stash
		fi
	fi

	#TODO: stop looping if checking out master or pulling fails
	if [ "$(git symbolic-ref --short HEAD)" != "master" ]; then
		if [ "$dryrun" ]; then
			echo "git checkout master && git pull"
			echo "git checkout $current_branch"
			testFail
		else
			echo "Updating master"
			git checkout master 
			git pull --commit --no-edit #don't open an editor -- just commit the change

			echo "Switching back to ${current_branch}"
			git checkout "$current_branch"
		fi
	else
		if [ "$dryrun" ]; then
			echo "git pull"
			testFail
		else
			echo "Updating master"
			git pull --commit --no-edit #don't open an editor -- just commit the change
		fi
	fi

	if [ $dirty -ne 0 ]; then
		if [ "$dryrun" ]; then
			echo "Dirty is ${dirty}"
			echo "git stash apply"
			testFail
		else
			echo "Unstashing changes"
			git stash apply
		fi
	fi
	dirty=false
}

#For each directory in the $WORKSPACE
for directory in "$WORKSPACE"/*/ ; do
	updateRepo
done

if [[ ${#failedRepos[@]} -ne 0 ]]; then
	echo -e \\n"\\033[0;31m]The following repos failed while updating"
	printf '%s\n' "${failedRepos[@]}"
else
	printf "\\n\\033[0;32mAll repos updated successfully\\n"
fi
