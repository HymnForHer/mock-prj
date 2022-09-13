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
            step
            steps{
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile ."
                withCredentials([usernamePassword(credentialsId: 'dockerRegis', 
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
                ansiblePlaybook(
                    credentialsId: 'TokyoKey',
                    disableHostKeyChecking: true,
                    installation : "Ansible",
                    playbook: 'mainTest.yml',
                    inventory: 'hosts',
                    become: 'yes',
                    extraVars: [
                        dockerVer: "${DOCKER_TAG}"
                    ]
                )
            }
        }

        stage("Build - Prod ENV"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            when{
                 expression { GITBRANCH == "main" }
            }
            step
            steps{
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile ."
                withCredentials([usernamePassword(credentialsId: 'dockerRegis', 
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
                ansiblePlaybook(
                    credentialsId: 'TokyoKey',
                    disableHostKeyChecking: true,
                    installation : "Ansible",
                    playbook: 'mainProd.yml',
                    inventory: 'hosts',
                    become: 'yes',
                    extraVars: [
                        dockerVer: "${DOCKER_TAG}"
                    ]
                )
            }
        }
    }
}
