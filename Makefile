validate:
	-git diff --name-only | grep template > .synclocal
	@while read line; do aws cloudformation validate-template --template-body file://$$line; done < .synclocal

uptmp:
	-git diff --name-only | grep template > .sync
	@while read line; do aws cloudformation validate-template --template-body file://$$line; done < .sync
	@git add --all
	@git diff --quiet --exit-code --cached || git commit -m "$m"
	@git push
	@echo "`date -u`"   >> .synclog
	@echo "`aws s3 sync . s3://cf-tmpl-parascm5 --exclude ".git/*" --exclude ".*" --delete`" >> .synclog
	@sed -i -e 's/^.*upload/upload/' .synclog


buildtest:
	@aws cloudformation create-stack --stack-name TestStack --template-body file://cloudformer.template --parameters ParameterKey=KeyPairName,ParameterValue=parascm5-key --region eu-central-1

updatetest:
	@aws cloudformation update-stack --stack-name TestStack --template-body file://cloudformer.template --parameters ParameterKey=KeyPairName,ParameterValue=parascm5-key --region eu-central-1

deltest:
	@aws cloudformation delete-stack --stack-name TestStack

checktest:
	@aws cloudformation describe-stacks --stack-name TestStack | grep Status
