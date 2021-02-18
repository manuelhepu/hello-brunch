#!/usr/bin/env groovy
pipeline {
    agent any
    
    options {
        ansiColor('xterm')
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
            
        }



        stage('trivy'){
            steps{
                sh 'trivy filesystem -f json -o trivy-fs.json .'
                sh 'trivy image -f json -o trivy-image.json hello-vue'
                recordIssues enabledForFailure: true, aggregatingResults:true, tool: trivy(pattern: 'trivy-*.json')
            }
    
           
            
        }


        

        

        stage('Publish') {
            steps {
                withDockerRegistry([credentialsId:"gitlabRegistry",url:"http://10.250.7.2:5050"]){
                    sh 'docker tag hello-vue:latest 10.250.7.2:5050/root/hello-brunch:BUILD-1.${BUILD_ID}'
                    sh 'docker push 10.250.7.2:5050/root/hello-brunch:BUILD-1.${BUILD_ID}'
                    sh 'docker tag hello-vue:latest 10.250.7.2:5050/root/hello-brunch:latest'
                    sh 'docker push 10.250.7.2:5050/root/hello-brunch:latest'
                    
                    sshagent (credentials: ['ssh_llave']) {
                        sh 'git tag BUILD-1.${BUILD_ID}'
                        sh 'git push --tags'
                    }
                }
            }
        }


        stage('Deploy') {
            steps {
                
                sshagent (credentials: ['ssh_deploy']) {
                sh 'ssh -t -o "StrictHostKeyChecking no"  deploy@10.250.7.2 "docker-compose pull && docker-compose up -d"'
                }
            }
        }

        

    }
}
