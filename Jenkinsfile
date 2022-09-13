pipeline {
    agent any

    stages {
        stage("Deploy") {
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            steps {
                ansiblePlaybook(
                    credentialsId: 'TokyoKey',
                    disableHostKeyChecking: true,
                    installation : "Ansible",
                    playbook: 'mainEnv.yml',
                    inventory: 'hosts',
                    become: 'yes',
                )
            }
        }
    }
}
