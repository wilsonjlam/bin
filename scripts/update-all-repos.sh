#!/bin/bash
#idea: when soemthing fails, have a "skip this one and output it as a failed repo"
dryrun=$1
declare -a failedRepos

handleFailure() {
	cmd=$1
	err=$2
	repo=$3

	if [ $err -ne 0 ]; then
		echo >&2 "\"$cmd\" failed with status \"$err\""
		failedRepos+=("$repo")
		continue
	fi
}

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

	cd -P $directory
	dirty=0
	current_branch="$(git symbolic-ref --short HEAD)"
	echo -e "\nCurrently in ${directory} on branch ${current_branch}"
	if [  -n "$(git status --short -uno 2> /dev/null | tail -n1)" ]; then
		dirty=1
		if [ $dryrun ]; then
			echo "Branch is dirty"
			echo "git stash"
			testFail
		else
			echo "Stashing"
			handleFailure "git stash" $? $directory
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
			handleFailure "git checkout master && git pull" $? $directory

			echo "Switching back to ${current_branch}"
			git checkout "$current_branch"
			handleFailure "git checkout $current_branch" $? $directory
		fi
	else
		if [ $dryrun ]; then
			echo "git pull"
			testFail
		else
			echo "Updating master"
			git pull
			handleFailure "git pull" $? $directory
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
			handleFailure "git stash apply" $? $directory
		fi
	fi
	dirty=false
done

if [[ ${failedRepos[@]} -ne 0 ]]; then
	echo ""
	echo -e "\033[0;31m]The following repos failed while updating"
	printf '%s\n' "${failedRepos[@]}"
else
	echo ""
	echo -e "\033[0;32mAll repos updated successfully"
	echo ""
fi
