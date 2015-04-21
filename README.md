# PostgreSQL-DocBuilder
Vagrant &amp; VirtualBox Configuration for PostgreSQL Documentation Editing on Ubuntu 14.04

## Overview

This repository provides scripts that facilitate the edit-build-review-submit
process associated with the PostgreSQL documentation changes.

## Installation

The **postgresql-doc.bash** script is the only file of value currently.
There are two commands of interest during installation:

* **init**: Installs dependencies and runs `configure`

* **install**: I am not convinced this is still required...but it
    creates a git-external-diff command under `git-core` in order to output
    a properly formatted diff/patch file.

## Usage

Note, it is assumed you have launched the virtual machine using **Vagrant**
and are logged into the desktop using the *vagrant* user.

Clone the git repository at `git://git.postgresql.org/git/postgresql.git`
into your `~/repos/postgresql` directory.

Clone this repository into your home directory.  Ensure the
**postgresql-doc.bash** script is executable.

Execute the `postgresql-doc.bash <command>`.  Review the script for
the definitions and programs each command executes.

The **build** command creates the HTML files using the website CSS.
Those files are found in `$DOC_DIR/html`.

Both `pgsql-hackers@postgresql.org` and `pgsql-docs@postgresql.org`
accepts documentation patches; and `pgsql-bugs@postgresql.org` should
be used for serious documentation errors.  I tend to use `-docs` instead
of `-hackers` for largely content enhancement patches.

## Planned Features

Eventually a Vagrant file will be provided that will setup the necessary
environment automatically.

The patch apply commands are not fully functioning as of yet but their
intent is to facilitate the review of patches that have been provided on
the mailing list.

The export process would ideally also generate either and HTML or PDF
file that could be attached to the email thread so that others can review
the layout of the result as well as the diffs.

