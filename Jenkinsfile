// pipeline {
//     agent any

//     tools {
//        go "1.24.1"
//     }
    
//     stages {
//         stage('Test'){
//             steps {
//                 sh "go test ./..."
//             }
//         }
//         stage('Build') {
//             steps {
//                 sh "go build main.go"
//                 sh "chmod +x main"
//             }
//         }
//         // stage('Deploy') {
//         //     steps {
//         //         withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
//         //         // sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@target:' 
//         //         sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory hosts.ini --key-file ${FILENAME} playbook.yaml'
//         //       }
//         //     }
//         //  }
//         stage('Build Docker Image') {
//                 steps {
//                     // sh "docker build . --tag myapp"
//                     sh "docker build --tag ttl.sh/myapp:2h ."
//               }
//          }
//           stage('Build Push Image') {
//                 steps {
//                     // sh "docker build . --tag myapp"
//                     sh "docker push ttl.sh/myapp:2h"
//               }
//          }
//         stage('Docker Run Image') {
//                 steps {
//                     withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
//                     sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker stop myapp || true'"
//                     sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker rm myapp || true'"           
//                     sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker run --name myapp --pull always -d -p 4444:4444 ttl.sh/myapp:2h'"   
//                    }
//               }
//          }
//      }
// }

pipeline {
  agent any

  tools {
    go "1.24.1"
  }

  environment {
    IMAGE = "ttl.sh/myapp:2h"
    APP_NAME = "myapp"
    APP_PORT = "4444"

    // IMPORTANT: change these
    EC2_HOST = "YOUR_EC2_PUBLIC_IP"
    EC2_USER = "ubuntu" // or ec2-user
  }

  stages {
    stage('Test') {
      steps {
        sh 'go test ./...'
      }
    }

    stage('Build Binary') {
      steps {
        sh 'go build -o main main.go'
        sh 'chmod +x main'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE} ."
      }
    }

    stage('Push Docker Image') {
      steps {
        sh "docker push ${IMAGE}"
      }
    }

    stage('Deploy to EC2') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'mykey',
                                           keyFileVariable: 'KEYFILE',
                                           usernameVariable: 'IGNORED')]) {

          sh """
            ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${EC2_USER}@${EC2_HOST} '
              set -e

              # Make sure docker exists
              docker --version

              # Stop old container
              docker stop ${APP_NAME} || true
              docker rm ${APP_NAME} || true

              # Pull + run
              docker pull ${IMAGE}
              docker run -d --name ${APP_NAME} --restart unless-stopped \\
                -p ${APP_PORT}:${APP_PORT} \\
                ${IMAGE}

              docker ps | head
            '
          """
        }
      }
    }

    stage('Verify') {
      steps {
        sh """
          curl -sS --max-time 10 http://${EC2_HOST}:${APP_PORT} || (echo 'NOT RESPONDING on ${EC2_HOST}:${APP_PORT}' && exit 1)
        """
      }
    }
  }
}
