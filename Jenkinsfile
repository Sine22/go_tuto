pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    stages {
        stage('Test') {
              steps {
                   sh "go test ./..."
              }
        }
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }
        // stage('Build Docker Image') {
        //         steps {
        //             // sh "docker build . --tag myapp"
        //             sh "docker build --tag ttl.sh/myapp:2h ."
        //       }
        //  }
        // stage('Build Push Image') {
        //         steps {
        //             // sh "docker build . --tag myapp"
        //             sh "docker push ttl.sh/myapp:2h"
        //       }
        //  }
        // stage('Docker Run Image') {
        //         steps {
        //             withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
        //             sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker stop myapp || true'"
        //             sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker rm myapp || true'"           
        //             sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker run --name myapp --pull always -d -p 4444:4444 ttl.sh/myapp:2h'"   
        //             }

        stage('Deploy') {
          steps {
              withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@13.251.114.108 "sudo systemctl stop myapp" || true' 
                sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@13.251.114.108'
            }
          }
        }
    }
}
