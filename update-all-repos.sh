#!/bin/bash

dryrun=$1
if [ $dryrun ]; then
	echo "Test catching failure y/n?"
	read testFailure
	failCode=11
	fail() {
		return $failCode
	}

	testFail() {
		if [ $testFailure == "y" ]; then
			fail
			retval=$?
			if [ $retval -ne 0 ]; then
				echo >&2 "ERROR: Failed with status $retval"
				exit 1
			fi
		fi
	}
fi

if [ ! -n "$WORKSPACE" ]; then
	echo "Please set the $WORKSPACE enviornment variable"
fi

#For each directory in the $WORKSPACE
for directory in $WORKSPACE/*/ ; do
	if [ ! -d $directory ] || [ ! -d $directory/.git ]; then
		echo "Skipping ${directory} since it's not a repo"
		continue
	fi

	cd $directory
	dirty=0
	current_branch="$(git symbolic-ref --short HEAD)"
	echo -e "\nCurrently in ${directory} on branch ${current_branch}"
	if [  -n "$(git status --short -u no 2> /dev/null | tail -n1)" ]; then
		dirty=1
		if [ $dryrun ]; then
			echo "Branch is dirty"
			echo "git stash"
			testFailure
		else
			echo "Stashing"
			git stash
			if [ $? -ne 0 ]; then
				echo >&2 "stashing failed with status $?"
				exit 1
			fi
		fi
	fi

	#TODO: stop looping if checking out master or pulling fails
	if [ "$(git symbolic-ref --short HEAD)" != "master" ]; then
		if [ $dryrun ]; then
			echo "git checkout master && git pull"
			echo "git checkout "$current_branch""
			testFail
		else
			echo "Updating master"
			git checkout master && git pull
			if [ $? -ne 0 ]; then
				echo >&2 "checking out and pulling on master failed with status $?"
				exit 1
			fi

			echo "Switching back to ${current_branch}"
			git checkout "$current_branch"
			if [ $? -ne 0 ]; then
				echo >&2 "switching branches failed with status $?"
				exit 1
			fi
		fi
	else
		if [ $dryrun ]; then
			echo "git pull"
			testFail
		else
			echo "Updating master"
			git pull
			if [ $? -ne 0 ]; then
				echo >&2 "pulling failed with status $?"
				exit 1
			fi
		fi
	fi

	if [ $dirty -ne 0 ]; then
		if [ $dryrun ]; then
			echo "Dirty is ${dirty}"
			echo "git stash apply"
			testFail
		else
			echo "Unstashing changes"
			git stash apply
			if [ $? -ne 0 ]; then
				echo >&2 "stash applying failed with status $?"
				exit 1
			fi
		fi
	fi
	dirty=false
done
