aws cloudformation create-stack \
    --region us-east-1 \
    --stack-name Pubsub-Dev \
    --template-body file://$(pwd)/pubsub.json \
    --parameters file:///$(pwd)/dev/us-east-1/pubsub-dev-us-east-1-parameters.json \
    --stack-policy-body file:///$(pwd)/policies/default-stack-policy.json

aws cloudformation create-stack \
    --region us-east-1 \
    --stack-name Pubsub-Dev-Iam \
    --template-body file://$(pwd)/pubsub-iam.json \
    --parameters file:///$(pwd)/dev/us-east-1/pubsub-iam-dev-parameters.json \
    --stack-policy-body file:///$(pwd)/policies/default-stack-policy.json \
    --capabilities CAPABILITY_IAM

aws cloudformation update-stack \
    --region us-east-1 \
    --stack-name Pubsub-Dev \
    --template-body file://$(pwd)/pubsub.json \
    --parameters file:///$(pwd)/dev/us-east-1/pubsub-dev-us-east-1-parameters.json

aws cloudformation update-stack \
    --region us-east-1 \
    --stack-name Pubsub-Dev-Iam \
    --template-body file://$(pwd)/pubsub-iam.json \
    --parameters file:///$(pwd)/dev/us-east-1/pubsub-iam-dev-parameters.json \
    --capabilities CAPABILITY_IAM
