pipeline { 
    agent any 
    environment { 
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id') 
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key') 
    } 
    stages { 
        stage('Terraform Initialization') { 
            steps { 
                sh 'terraform init' 
                sh 'pwd' 
                sh 'ls -al' 
                sh 'printenv' 
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
            } 
        }
        stage('archive terrafrom plan output') {
            steps {
                archiveArtifacts artifacts: 'terraform_plan', excludes: 'output/*.md', onlyIfSuccessful: true
            }
        }
        stage('Terraform Apply') { 
            steps { 
                sh 'terraform apply -auto-approve'
            } 
        } 
    } 
}
