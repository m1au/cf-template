
uptmp:
	-git diff --name-only | grep template > .sync
	@while read line; do aws cloudformation validate-template --template-body file://$$line; done < .sync
	@git add --all
	@git diff --quiet --exit-code --cached || git commit -m "$m"
	@git push
	@echo "`date -u`"   >> .synclog
	@echo "`aws s3 sync . s3://cf-tmpl-parascm5 --exclude ".git/*" --exclude ".*" --delete`" >> .synclog
	@sed -i -e 's/^.*upload/upload/' .synclog

dontdo:
	ls -al


