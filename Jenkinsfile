pipeline { 
    agent any
    environment { 
        AWS_ACCESS_KEY_ID     = credentials('IAM_USER_ACCESS_KEY') 
        AWS_SECRET_ACCESS_KEY = credentials('IAM_USER_SECRET_ACCESS_KEY')
    }
    stages { 
        stage('Terraform Initialization') { 
            steps { 
                sh 'terraform init || terraform init -upgrade'
            } 
        } 
        stage('Terraform Format') { 
            steps { 
                sh 'terraform fmt -check || exit 0' 
            } 
        } 
        stage('Terraform Validate') { 
            steps { 
                sh 'terraform validate'
            } 
        }
        stage('SonarQube Analysis') {
           steps {
               script {
                   def scannerHome = tool 'sonarqube-1';
                   withSonarQubeEnv('sonarqube-1') {
                       sh "${scannerHome}/bin/sonar-scanner"
                   }
               }
           }
        }
        stage('Terraform Planning') { 
            steps { 
                sh 'terraform plan -no-color -out=terraform_plan'
                sh 'terraform show -json ./terraform_plan > terraform_plan.json'
            } 
        }
        stage('archive terrafrom plan output') {
            steps {
                archiveArtifacts artifacts: 'terraform_plan.json', excludes: 'output/*.md', onlyIfSuccessful: true
            }
        }
        stage('Review and Run terraform apply') {
            steps {
                script {
                    env.selected_action = input  message: 'Select action to perform',ok : 'Proceed',id :'tag_id',
                    parameters:[choice(choices: ['apply', 'abort'], description: 'Select action', name: 'action')]
                }
            }
        }
        stage('Terraform Apply') { 
            steps {
                script {
                    if (env.selected_action == 'apply') {
                        sh 'terraform apply -auto-approve'
                    } else {
                        sh 'echo Review failed and terraform apply was aborted'
                        sh 'exit 0'
                    }
                }   
            }
        }
        stage('Run terraform destroy or not?') {
            steps {
                script {
                    env.selected_action = input  message: 'Select action to perform',ok : 'Proceed',id :'tag_id',
                    parameters:[choice(choices: ['destroy', 'abort'], description: 'Select action', name: 'action')]
                }
            }
        }
        stage('Terraform Destroy') { 
            steps {
                script {
                    if (env.selected_action == "destroy") {
                        sh 'terraform destroy -auto-approve'
                    } else {
                        sh 'echo We are not destroying the resource initialted, aborted!!!'
                        sh 'exit 0'
                    }
                }
            } 
        }
    } 
}
