
uptmp:
	git add --all
	git diff --quiet --exit-code --cached || git commit -m "$m"
	git push
	aws s3 sync . s3://cf-templates-parascm5 --exclude ".git/*" --delete

