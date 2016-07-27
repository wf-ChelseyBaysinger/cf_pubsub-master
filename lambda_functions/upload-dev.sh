rm /tmp/PubsubECSSCaling-dev.zip 
rm /tmp/PubsubESForwarder-dev.zip 
cd PubsubECSScaling/PubsubECSScaling-dev && zip /tmp/PubsubECSSCaling-dev.zip * && cd -
cd PubsubESForwarder/PubsubESForwarder-dev && zip /tmp/PubsubESForwarder-dev.zip * && cd -
zip /tmp/nocode.zip nocode
aws s3 cp /tmp/PubsubECSScaling-dev.zip s3://cloudops-dev-lambda-code/Pubsub-dev/
aws s3 cp /tmp/PubsubESForwarder-dev.zip s3://cloudops-dev-lambda-code/Pubsub-dev/
aws s3 cp /tmp/nocode.zip s3://cloudops-dev-lambda-code/Pubsub-dev/
