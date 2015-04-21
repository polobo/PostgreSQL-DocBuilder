#!/usr/bin/env bash
# Custom Interface to work with PostgreSQL Documentation

ACTION="${1}"
BRANCH="branch-${2:-''}"
FILE="${3:-''}"
BASE="/vagrant"

INPUTFILE="${BASE}/${BRANCH}/${FILE}"
REPO_BASE=~/"repos/postgresql"
DOC_DIR=~/"repos/postgresql/doc/src/sgml"
cd $DOC_DIR

# Build the documentation artifacts using the website stylesheet
# in order to preview presentation
if [ $ACTION = 'build' ]; then
	(cd $DOC_DIR && make check && make html STYLE=website)
fi

# Build draft artifacts in order to check for errors
# and quickly preview content.
if [ $ACTION = 'review' ]; then
	(cd $DOC_DIR && make check && make draft)
fi

# TODO: create a whole-branch diff and a last-commit diff
if [ $ACTION = 'export-diff' ]; then
  # perform a git diff and save the results
  #in the /vagrant directory
fi

# Apply using "git apply" command
if [ $ACTION = 'apply' ]; then
	stat $INPUTFILE
fi

# Apply using "patch" command
if [ $ACTION = 'patch' ]; then
	patch -p1 -i $INPUTFILE
fi

# Install the custom configuration required to work with
# this specific repository
if [ $ACTION = 'install' ]; then
	sudo tee /usr/lib/git-core/git-external-diff <<TXT
#!/bin/bash

# This script is used to produce git context diffs

# Supplied parameters:
# $1   $2       $3       $4       $5       $6       $7
# path old-file old-hash old-mode new-file new-hash new-mode
# 'path' is the git-tree-relative path of the file being diff'ed

old_hash="$3"
new_hash=$(git hash-object "$5")

# no change?
[ "$old_hash" = "$new_hash" ] && exit 0

[ "$DIFF_OPTS" = "" ] && DIFF_OPTS='-pcd'

echo "diff --git a/$1 b/$1"
echo "new file mode $7"
echo "index ${old_hash:0:7}..${new_hash:0:7}"

diff --label a/"$1" --label b/"$1" $DIFF_OPTS "$2" "$5"

exit 0
TXT
fi

# Install the dependencies required for building the documentation
# It doesn't hurt to update if they are already installed and for
# generalized virtual machines the standard provisioning script
# probably will not include this.
# Ideally we would make use of "chef" provisioning somehwhere
# but for now this script can depend on Ubuntu (maybe Debian...)
if [ $ACTION = 'init' ]; then
	# Initialize the machine to be able to build the documentation
	sudo apt-get update
	sudo apt-get install docbook docbook-dsssl docbook-xsl openjade1.3 opensp xsltproc
	# for undocumented xmllint requirement
	sudo apt-get install libxml2-utils
	${REPO_BASE}/configure
fi;

exit 0
