# Terraform Practical Test

* Fork this repo into your own bitbucket/github/gitlab repo and make it *public* along with any other downstream repos that it requires
* share the repo with your examiner

## Objective:
This practical test will assess your ability to work with 
* Git (forking, pull, push, commit, tagging)
* Terraform (modules, data resources, variables etc)
* AWS resources (AWS terraform provider)
* Ansible automation (OS provisioning)
* Makefile creation (CI/CD, DevOps)
 
The test consists of multiple tasks, and you will be scored on your ability to:

* Forking this repo, and using git processes
* Write Terraform code to provision AWS resources.
* Use a Makefile to automate Terraform commands.
* Modularize Terraform code.
* Write basic Ansible code for automation.


## Assumptions
Your code will be run on a fresh WSL Ubuntu in a windows environment.

1. make has been installed via apt

2. these steps have been run in this ubuntu environment : https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli so that the latest version of hashicorp terraform is available

3. the ~/.aws/credentials file will have a default profile set with Admin Access to an AWS account, assume permissions to AWS have been set correctly, we just copy the keys from SSO directly and rename the profile to default.
eg, our `~/.aws/credentials` file will look like this with the appropriate values

```
[default]
aws_access_key_id=
aws_secret_access_key=
aws_session_token=
```

4. the region has been set by default to `ap-southeast-2` via `terraform.tfvars`

5. there is a default VPC in place in our AWS account that the data resource will pick up in that region in `terraform.tf`

6. There will be 3 public subnets in a/b/c that route to the internet gateway in the VPC, There are no private subnets or NAT gateways, this isn't a networking test aside from basic security group attached to an EC2 with ssh access

7. some base code has been pre-written to return the VPC and subnets and userdata module to install and call ansible and return the value as a base64 gzipped string

---

## Tasks Overview:

#### CoPilot/ChatGPT
*For any tasks where you use CoPilot or ChatGPT to generate the code, feel free to do so, however you will still be expected to justify your solution approach and workings*

*Feel free to include the prompts used in the documentation for unfamiliar sections of the test*

*We have asked ChatGPT and CoPilot to make some of the task wording a little bit more ambiguous so that a simple copy/paste will generate incorrect solutions, or miss obvious easy points. If you need clarification, reach out*

#### 1. Makefile Automation (20 points)**

Automate the initialization, planning, execution, and removal processes in a `Makefile`.

    (10 points) All processes are automated, initialization included even if not directly called.
    (5 points) Include comments in the Makefile.
    (5 points) Ensure it works with general configurations and includes other steps.

##### 1.1. To Mark this section we will:
Run from the repo *root* folder:
  * `make <your documented options>`
  * examples
    ```
    make <option> project_folder # features you deem important
    ```

---
#### 2. Terraform AWS EC2 (35 points)**: 
**Create 3 Ubuntu EC2 instances with supplied USERDATA in** *public subnet a,b and c*
    * (10 Points) Implement an automatic adjustable provisioning method
    * (10 Points) EC2s run supplied cloud-init correctly
    * (5  Points) AMI uses the latest amazon/canonical AMI at apply stage
    * (5  points) Correct Subnets, Correct use of existing resources in main.tf
    * (5  Points) Outputs added for ssh private/public keys used

##### 2.2. To Mark this section we will:
  * check that 3 EC2 instances have been created
  * check what AZ each EC2 is created in for `aws_instance` resource
  * check if the EC2 is via a method *not* using `aws_instance` and provisioning values
  * check any `count`/`for_each`/`dynamic` options for `aws_instance` or other methods
  * check AMI selection process
  * check userdata parameters used
  * check if the VPC resources in terraform.tf were used, or a valid reason for a new VPC (eg permissions)
  * check outputs for any ssh key pairs used, we use this to remote into a EC2 and check further
  * `ssh -i custom_rsa_private_key_value ubuntu@public-ip-address`

---
#### 3. **Terraform Module Calls (20 points)**
**Use a Terraform module to manage AWS resources**
    * (5 Points) Ensure that common settings are predefined for the modules.
    * (5 points) Keep the modules either within the project *or*
    * (5+5 points) Reference repositories as needed for modules. 
    * (5 points) Use specific versions of modules in the setup.

##### 3.1. To Mark this section we will:
  * check module for default variable values, and what variables available
  * check if module code is referenced locally or 
  * check if another method is used to reference a module
  * check if module versioning is setup

---

#### 4. **Basic Ansible Playbook (15 points)**
**Write a basic Ansible playbook to create a dummy file with permissions in /opt.**
    * (5 Points) Ansible playbook correctly creates a file on the EC2 instances with linux permissions of 664 or rw-rw-r-- in /opt folder.
    * (5 points) The playbook is idempotent (i.e., running it multiple times does not create duplicate files).
    * (5 points) Ansible code uses a role for the create dummy file tasks, with parameters for the filename

##### 4.1. To Mark this section we will:
  * check ansible code for dummy tasks
  * check permissions locally on EC2 (if ssh keys available)
  * rerun `ansible-playbook /opt/<repo name>/ansible/startup.yml`
  * delete the dummy file, and rerun playbook again
  * check ansible code and structure for role: and associated role folders + dummy filename variable

---

#### 5. **Documentation (10 points)**
**Document the steps to provision the resources and execute the tests**
    * (5 Points) Clear examples of what to run, and what order
    * (5 points) tf code and variables is documented

##### 5.1. To Mark this section we will:
  * check for any `*.md` files in the root of the repo for further instructions
  * check any additional code supplied has `# comments` and the content
  * check any auto-generated docs if available

---


**Total**: 100 points

Good luck!
