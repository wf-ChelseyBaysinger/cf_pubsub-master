aws cloudformation create-stack \
    --region us-east-1 \
    --stack-name Pubsub-Prod-Iam \
    --template-body file://$(pwd)/pubsub-iam.json \
    --parameters file:///$(pwd)/prod/pubsub-iam-prod-parameters.json \
    --stack-policy-body file:///$(pwd)/../../policies/default-stack-policy.json \
    --capabilities CAPABILITY_IAM

aws cloudformation create-stack \
    --region us-east-1 \
    --stack-name Pubsub-Prod-us-east-1 \
    --template-body file://$(pwd)/pubsub.json \
    --parameters file:///$(pwd)/prod/us-east-1/pubsub-prod-us-east-1-parameters.json \
    --stack-policy-body file:///$(pwd)/../../policies/default-stack-policy.json

aws cloudformation create-stack \
    --region us-west-2 \
    --stack-name Pubsub-Prod-us-west-2 \
    --template-body file://$(pwd)/pubsub.json \
    --parameters file:///$(pwd)/prod/us-west-2/pubsub-prod-us-west-2-parameters.json \
    --stack-policy-body file:///$(pwd)/../../policies/default-stack-policy.json

aws cloudformation update-stack \
    --region us-east-1 \
    --stack-name Pubsub-Prod-Iam \
    --template-body file://$(pwd)/pubsub-iam.json \
    --parameters file:///$(pwd)/prod/pubsub-iam-prod-parameters.json \
    --capabilities CAPABILITY_IAM

aws cloudformation update-stack \
    --region us-east-1 \
    --stack-name Pubsub-Prod-us-east-1 \
    --template-body file://$(pwd)/pubsub.json \
    --parameters file:///$(pwd)/prod/us-east-1/pubsub-prod-us-east-1-parameters.json \

aws cloudformation update-stack \
    --region us-west-2 \
    --stack-name Pubsub-Prod-us-west-2 \
    --template-body file://$(pwd)/pubsub.json \
    --parameters file:///$(pwd)/prod/us-west-2/pubsub-prod-us-west-2-parameters.json \
