pipeline {
    agent{
        label 'my-agent-1'
    }
    tools{
        terraform 'terraform'
        ansible 'ansible'
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }     
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git branch: 'main', url: 'https://github.com/Sameerpatlekar/Terraform-Jenkins.git'
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init'
                sh "pwd;cd terraform/ ; terraform plan -out tfplan"
                sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
            }
        }
        stage('create inventory file') {
            steps {
                sh 'pwd;cd terraform/ ; bash generate_inventory.sh'
            }
        }

        stage('ping server') {
            steps {
               ansiblePlaybook credentialsId: 'jenkins_private-ansible', installation: 'ansible', inventory: 'inventory.ini', playbook: 'playbook.yml', vaultTmpPath: ''
                }
            }
    }
    post {
        success {
            echo 'Build was successful, cleaning workspace...'
            cleanWs()
        }
        failure {
            echo 'Build failed, not cleaning workspace.'
        }
    }
  }
