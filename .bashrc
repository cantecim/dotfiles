export LANG=en_US.UTF-8
export LC_ALL=$LANG
export LANGUAGE=$LANG

mkcdir ()
{
	mkdir -p -- "$1" && cd -P -- "$1"
}

commitWithMessage() {
	message="$*"
	git commit -m "$message"
}

ec2Fingerprint() {
	openssl pkcs8 -in $1 -nocrypt -topk8 -outform DER | openssl sha1 -c
}
