mkcdir ()
{
	mkdir -p -- "$1" && cd -P -- "$1"
}

commitWithMessage() {
	message="$*"
	git commit -m "$message"
}
