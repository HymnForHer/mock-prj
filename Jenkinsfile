pipeline{
    agent any 
    environment {
        DOCKER_IMAGE="hymn208/mock-phase-2"
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
        GITBRANCH = "${GIT_BRANCH.tokenize('/').pop()}"
    }
    stages{
        stage("Build - Test ENV"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            when{
                 expression { GITBRANCH == "dev" }
            }
            steps{
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile ."
                withCredentials([usernamePassword(credentialsId: 'DockerHub', 
                                                  usernameVariable: 'DOCKER_USER' , 
                                                  passwordVariable: 'DOCKER_PASS')]) 
                {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
        stage("Deploy - Test ENV"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            when{
                 expression { GITBRANCH == "dev" }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub', 
                                                  usernameVariable: 'DOCKER_USER' , 
                                                  passwordVariable: 'DOCKER_PASS')]) 
                {
                    ansiblePlaybook(
                        credentialsId: 'TokyoKey',
                        disableHostKeyChecking: true,
                        installation : "Ansible",
                        playbook: 'mainTest.yml',
                        inventory: 'hosts',
                        become: 'yes',
                        extraVars: [
                            dockerVer: "${DOCKER_TAG}",
                            dockerUser: "${DOCKER_USER}",
                            dockerPasswd: "${DOCKER_PASS}"
                        ]
                    )   
                } 
            }
        }

        stage("Build - Prod ENV"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            when{
                 expression { GITBRANCH == "main" }
            }
            steps{
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile ."
                withCredentials([usernamePassword(credentialsId: 'DockerHub', 
                                                  usernameVariable: 'DOCKER_USER' , 
                                                  passwordVariable: 'DOCKER_PASS')]) 
                {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
        stage("Deploy - prod ENV"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            when{
                 expression { GITBRANCH == "main" }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHub', 
                                                  usernameVariable: 'DOCKER_USER' , 
                                                  passwordVariable: 'DOCKER_PASS')]) 
                {
                    ansiblePlaybook(
                        credentialsId: 'TokyoKey',
                        disableHostKeyChecking: true,
                        installation : "Ansible",
                        playbook: 'mainProd.yml',
                        inventory: 'hosts',
                        become: 'yes',
                        extraVars: [
                            dockerVer: "${DOCKER_TAG}",
                            dockerUser: "${DOCKER_USER}",
                            dockerPasswd: "${DOCKER_PASS}"
                        ]
                    )   
                }
            }
        }
    }
}


