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
//                     sh "docker build --tag ttl.sh/myapp:1h ."
//               }
//          }
//           stage('Build Push Image') {
//                 steps {
//                     // sh "docker build . --tag myapp"
//                     sh "docker push ttl.sh/myapp:1h"
//               }
//          }
//         stage('Deploy to Kubernetes') {
//                 steps {
//                         withKubeConfig ([credentialsId: 'myapikey', serverUrl: 'https://kubernetes:6443']) {
//                         // sh 'kubectl apply -f deployment.yaml --namespace production' 
//                         // sh 'kubectl apply -f service.yaml --namespace production'
//                         sh 'kubectl apply -f pod.yaml'
//                     }                
//               }
//          }
//      }
// }

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
        stage('Build Docker Image') {
            steps {
                sh "docker build . --tag ttl.sh/sine:1h"
            }
        }
        stage('Build Push Image') {
            steps {
                sh "docker push ttl.sh/sine:1h"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                 withKubeConfig([credentialsId: 'myapikey', serverUrl: 'https://kubernetes:6443']) {
                  // sh 'kubectl apply -f deployment.yaml'
                  // sh 'kubectl apply -f service.yaml'
                     sh 'kubectl apply -f pod.yaml'
                }
            }
        }
    }
}
