## Pubsub CloudFormation Stacks

Cloudformation for ECS consists of two stacks; **pubsub and pubsub-iam**

Configurable parameters including region specific settings are contained in in the -parameters.json files relative to each stack's template, as well as in the "Mappings" section of the template.  For example, the IAM instance profile created by pubsub-s3.json is a parameter you must update in the pubsub-dev-parameter.json template in the **Mappings** section.

  * **pubsub.json** *is configured by* **pubsub-dev-parameters.json**.
  * **pubsub-iam.json** *is configured by* **pubsub-dev-iam-parameters.json**.

Some parameters are shared by the cloudformation stacks creating a dependency between the parameters shared among stacks.  When a shared parameter is updated, the dependent stack(s) will need to match the parameter value change in their mappings and perform an update-stack.  (these parameters can be identified by the use of Fn:FindInMap intrinsic function in the json for the stack you are updating.)

For more information on intrinsic functions visit the AWS documentation [here](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html).


## Stacks in order of deployment for dependencies
### VPC
* Creates VPC for use by pubsub stack.
  * Mappings for the VPC, subnets, AZs, and DefaultSG created by VPC stack must be in the pubsub parameter file.
* Alternatively, an existing VPC may be used

###	pubsub-iam 
* Creates pubsub Iam roles
* Parameters used
    * TODO
* Required cloudformation stacks
  * **VPC** (VPC)

### Manual setup

#### ElasticSearch
* Create an elasticsearch cluster 
    * Prod 
        * Instance type: r3.xlarge.elasticsearch 
        * Instance count: 7
        * Enable dedicated master: checked
        * Dedicated master type: m3.medium.elasticsearch 
        * Dedicated master instance count: 3
        * Enable zone awareness: unchecked
        * Storage type: EBS
        * EBS volume type: Provisioned IOPS
        * EBS volume size: 512
        * Provisioned IOPS: 4000
        * Advanced Options: rest.action.multi.allow_explicity_index: false
        * Advanced Options: infices.fielddata.cache.size: <blank>
        * Policy that allows the corp and prod VPNs IPs: 54.84.91.45/32,52.0.10.41/32
* Once the elasticsearch cluster has been created, update the PubsubESForwarder code for that environment with its endpoint

#### Lambda Code
* Create a bucket to host the lambda code. Set up logging and versioning as appropriate. The bucket name will be a parameter for the pubsub stack
* Upload the following lambda functions to it
    * PubsubECSScaling
    * PubsubESForwarder

###	pubsub (or other environment specific extension)
* Dependent upon VPC, pubsub-iam 
* Creates an ELB
* Creates an ASG + scaling parameters + Launch Configs
* Creates Security Groups
* Parameters used
    * TODO
* Required cloudformation stacks
    * **pubsub-iam** (TODO)
    * **VPC** (VPCId)
        * Mappings for the VPC, subnets, AZs, and DefaultSG created by VPC stack must be in the pubsub parameter file.

### Manual setup
* Since kinesis firehose and elasticsearch support for cloudformation does not exist and kinesis support does not allow specifying a stream name, these resources should be configured manually. 
#### Kinesis firehose
* Create a kinesis firehose stream with two shards pointing to an S3 bucket
