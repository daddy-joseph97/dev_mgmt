# sanity savers and helpers
function copy_smrt {
	# if a regular file, copy to provided path ($2)
	if [ -f "$1" ]
	then
		echo "passed file test, copying..."
		cp "$1" "$2"
	# however if a directory, then copy recursively
	elif [ -d "$1" ]
	then
		echo "passed directory test, copying..."
		cp -a "$1" "$2"
	fi
	# not concerned with symlink handling yet
}

function symlink_smrt {
	# desire is to link but only if not already present, whether link,
	# file or directory
	# probably a better way
	if [ -e "$1" ] && [ ! -e "$2" ]
	then
		ln -s "$1" "$2"
	fi
}
