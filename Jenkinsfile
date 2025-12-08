pipeline {
    agent any

    tools {
       go "1.24.1"
    }
    
    stages {
        stage('Test'){
            steps {
                sh "go test ./..."
            }
        }
        stage('Build') {
            steps {
                sh "go build main.go"
                sh "chmod +x main"
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                // sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@target:' 
                sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory hosts.ini --key-file ${FILENAME} playbook.yaml'
              }
            }
         }
     }
 }
