
uptmp:
	-git diff --name-only | grep template > .sync
	@git add --all
	@git diff --quiet --exit-code --cached || git commit -m "$m"
	@git push
	@aws s3 sync . s3://cf-tmpl-parascm5 --exclude ".git/*" --exclude ".*" --delete > .synclog
	while read line; do aws cloudformation validate-template --template-body file://$$line; done < .sync

dontdo:
	ls -al
