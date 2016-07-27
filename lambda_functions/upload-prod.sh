rm /tmp/PubsubECSSCaling-prod.zip 
rm /tmp/PubsubESForwarder-prod.zip 
cd PubsubECSScaling/PubsubECSScaling-prod && zip /tmp/PubsubECSSCaling-prod.zip * && cd -
cd PubsubESForwarder/PubsubESForwarder-prod && zip /tmp/PubsubESForwarder-prod.zip * && cd -
zip /tmp/nocode.zip nocode
aws s3 cp /tmp/PubsubECSScaling-prod.zip s3://cloudops-prod-lambda-code/Pubsub-prod/
aws s3 cp /tmp/PubsubESForwarder-prod.zip s3://cloudops-prod-lambda-code/Pubsub-prod/
aws s3 cp /tmp/nocode.zip s3://cloudops-prod-lambda-code/Pubsub-prod/
