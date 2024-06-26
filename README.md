# demo

# Description
# ALB module
module alb "terraform-aws-modules/alb/aws"
  Listeners on https 443. Forward to only one target group with port 8080 on which container operates.
  Security groups loaded from data as previosuly created description given in separate part
  All subnets attached to alb and found via data source
  Security groups attached all. 
  For alb it is required to use administrator access role. Make sure this group is used by this part of pipeline only.

  Improvements:
    Cloudwatch configuration for future
    Rules for forwarding to proper endpoints
    Security improvement to be made to attach only https and http groups
    Topic to go into for security improvement is who will be having access to it - maybe some OIDC mechanisms?
    kms key to encrypt communication between alb and tasks, as well as logs encryption

# Cluster
  aws_ecs_cluster resource
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster

  Improvements:
    cloudwatch configuration
    a proper iam role to be used by the pipeline in order to create clister
    A parameter service connect defaults could be used in order to not configure service connect in each aws_ecs_service. For multi namespace scenario, such configuration in aws_ecs_service will be needed anyway.

# ECS Task
  Main resource: 
    aws_ecs_service
      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
    aws_ecs_task_definition
      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition

  Improvements:
    Probes configuration
    Volumes configuration
    Cloudwatch configuration
    Secrets attached to the pod as for example for accessing RDS.
    Task tests in different load scenario in order to make resource allocation and scaling configuration appropriate.
    IAM role for ecs task deployment only and used by the pipeline.
    KMS keys configuration for communication encryption between other services and alb
    Service connect configuration could be deprecated and replaced by default connect configuration. In such the dns_name would left.
    Alarms for cloudwatch

# RDS
  module rds "terraform-aws-modules/rds/aws"
    https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
  
  Improvements:
    IAM role based database authentication - feature to have a look at
    Python script and ECS task for initial database creation and tables configuration
    Cloudwatch logs enabling together with kms keys based encryption

# rest-app
  Improvements:
    separating flask in order to run probes on different ports
    This would be a base image for every rest service, while all the scripts, apps and so one could be loaded together with volumes attached.

# security-groups
  resources: aws_security_group
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group


# service discovery configuration
  resources:
    aws_service_discovery_private_dns_namespace
      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace
    aws_service_discovery_service
      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_service.html
    
  Assumptions:
    private dns for communication within cluster by the namespace suffix
    Service discovery within namespace only with basic type A records.
  
  Improvements:
    Not sure how to enable dns for rds just to variable only prefix of the rds address instead of putting rds address to the container via some job and environment variable
    DNS healthchech introduction
    
# terraform templates
  Instead of copying terraform configuration files and keeping them in each repo section, they are copied during pipeline job execution from directory.

# vpc
  module vpc used source = "terraform-aws-modules/vpc/aws"
  https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

  Assumptions:
    private, public and database subnets are created. But private and database will be used mostly as no communication to specific container or RDS from outside.
    ALB is having public subnet assigned as well.
    two availability zones have bee configured. With this configuration RDS is having two instances, but configured ECS task runs at one AZ only - one instance
    Default behavior for nat gateway is used - one per subnet
  
  Improvements:
    remove public access to DB from this configuration
    ip planning

# gitlab pipeline
  Improvements:
    A better IAM role managing. Currently only one configured and used by all jobs.
    In the context of variables. There is one place needed for variables configuration instead of configuring them manually in each directory/job. Some python script would be useful in order to propagate specific variables to their wright location.
    TF_VAR_ mechanisms could be used instead on loading yaml by the local feature.

# terraform backend
  configured using http backend at gitlab and TF variables exported from ci/cd variables

# related docs
  - Set up
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/get-set-up-for-amazon-ecs.html
  - Create ALB
    https://repost.aws/knowledge-center/create-alb-auto-register
  - Port mappings for task definition
    https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PortMapping.html
  - AWS Service connect
    https://stackoverflow.com/questions/75213261/aws-service-connect-with-terraform
  - Create a container image and upload to ecr
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html
  - Create ECS linux task on FARGATE
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/getting-started-fargate.html
  - Creating a task definition
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-definition-template.html
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/example_task_definitions.html
  - Creating a cluster
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-cluster-console-v2.html
  - best practices
    https://docs.aws.amazon.com/AmazonECS/latest/developerguide/security-iam-bestpractices.html
  - General terraform
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    https://developer.hashicorp.com/terraform/language
  - Terraform backend config
    https://developer.hashicorp.com/terraform/language/settings/backends/remote


## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/onelittlecloud/demo.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/onelittlecloud/demo/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
