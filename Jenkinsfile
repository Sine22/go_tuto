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
        // stage('Deploy') {
        //     steps {
        //         withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
        //         // sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@target:' 
        //         sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory hosts.ini --key-file ${FILENAME} playbook.yaml'
        //       }
        //     }
        //  }
        stage('Build Docker Image') {
                steps {
                    sh "docker build . --tag myapp"
              }
         }
        stage('Docker Run Image') {
                steps {
                    withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                    sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker stop myapp || ture'"
                    sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker rm myapp || ture'"
                    sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker run -d -p 4444:4444 ttl.sh/myapp:1h'"   
                   }
              }
         }
     }
}
