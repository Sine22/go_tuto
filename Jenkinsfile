// pipeline {
//     agent any

//     tools {
//        go "1.24.1"
//     }

//     stages {
//         stage('Test') {
//               steps {
//                    sh "go test ./..."
//               }
//         }
//         stage('Build') {
//             steps {
//                 sh "go build main.go"
//             }
//         }
//         stage('Build Docker Image') {
//                 steps {
//                     // sh "docker build . --tag myapp"
//                     sh "docker build --tag ttl.sh/myapp:2h ."
//               }
//          }
//         stage('Build Push Image') {
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
//                     }

//         stage('Deploy') {
//           steps {
//               withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
//                 sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@18.143.194.166 "sudo systemctl stop myapp" || true' 
//                 sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@18.143.194.166'
//             }
//           }
//         }
//     }
// }

pipeline {
  agent any

  tools {
    go "1.24.1"
  }

  environment {
    IMAGE = "ttl.sh/myapp:2h"
    APP_NAME = "myapp"
    EC2_HOST = "18.143.194.166"
    EC2_USER = "ubuntu"   // change to ec2-user if Amazon Linux
  }

  stages {
    stage('Test') {
      steps {
        sh 'go test ./...'
      }
    }

    stage('Build') {
      steps {
        sh 'go build -o main main.go'
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

    stage('Deploy (Docker on EC2)') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'mykey',
                                           keyFileVariable: 'KEYFILE',
                                           usernameVariable: 'IGNORED')]) {
          sh """
            ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${EC2_USER}@${EC2_HOST} '
              set -e
              docker --version

              docker stop ${APP_NAME} || true
              docker rm ${APP_NAME} || true

              docker pull ${IMAGE}
              docker run -d --name ${APP_NAME} --restart unless-stopped \
                -p 4444:4444 \
                ${IMAGE}

              docker ps | head
            '
          """
        }
      }
    }

    stage('Verify') {
      steps {
        sh "curl -sS --max-time 10 http://${EC2_HOST}:4444"
      }
    }
  }
}

 
         
       
