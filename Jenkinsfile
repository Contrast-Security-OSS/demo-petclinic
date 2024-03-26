pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    stages {
        stage('dependencies') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.contrast_yaml, variable: 'path')]) {
                        def contents = readFile(env.path)
                        writeFile file: 'contrast_security.yaml', text: "$contents"
                    }
                }
                sh '''
                terraform init -upgrade
                npm i @playwright/test@1.42.1 --no-bin-links --no-save
                npx playwright@1.42.1 install --with-deps chromium
                '''
            }
        }
        stage('provision') {
            steps {
                script {
                    withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                        try {
                            sh """
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$AZURE_TENANT_ID
                            terraform apply -auto-approve -var 'location=$location' \
                                -var 'initials=$initials' \
                                -var 'environment=qa' \
                                -var 'servername=jenkins' \
                                -var 'session_metadata=branchName=qa,committer=Ryan,buildNumber=${env.BUILD_NUMBER}'
                            """
                        } catch (Exception e) {
                            echo 'Terraform refresh failed, deleting state'
                            sh 'rm -rf terraform.tfstate'
                            currentBuild.result = 'FAILURE'
                            error('Aborting the build.')
                        }
                    }
                }
            }
        }
        stage('sleeping') {
            steps {
                timeout(5) {
                    script {
                        waitUntil {
                            def r = sh returnStatus: true, script: "FQDN=\$(terraform output --raw fqdn); wget --retry-connrefused --tries=300 --waitretry=1 \$FQDN -O /dev/null"
                            return (r == 0)
                        }
                    }
                }
            }
        }
        stage('exercise') {
            steps {
                timeout(5) {
                    sh """
                    FQDN=\$(terraform output --raw fqdn)
                    BASEURL=\$FQDN npx playwright@1.32.1 test e2e/assess/*.ts
                    """
                }
            }
        }
        stage('provision - dev') {
            steps {
                script {
                    withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                        try {
                            sh """
                            export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                            export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                            export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                            export ARM_TENANT_ID=$AZURE_TENANT_ID
                            terraform apply -auto-approve -var 'location=$location' \
                                -var 'initials=$initials' \
                                -var 'environment=development' \
                                -var 'servername=Macbook-Pro' \
                                -var 'session_metadata=branchName=feat: improve owner search,committer=Jake,buildNumber=${env.BUILD_NUMBER}'
                            """
                        } catch (Exception e) {
                            echo 'Terraform refresh failed, deleting state'
                            sh 'rm -rf terraform.tfstate'
                            currentBuild.result = 'FAILURE'
                            error('Aborting the build.')
                        }
                    }
                }
            }
        }
        stage('sleeping - dev') {
            steps {
                timeout(5) {
                    script {
                        waitUntil {
                            def r = sh returnStatus: true, script: "FQDN=\$(terraform output --raw fqdn); wget --retry-connrefused --tries=300 --waitretry=1 \$FQDN -O /dev/null"
                            return (r == 0)
                        }
                    }
                }
            }
        }
        stage('exercise - dev') {
            steps {
                timeout(5) {
                    sh """
                    FQDN=\$(terraform output --raw fqdn)
                    BASEURL=\$FQDN npx playwright@1.32.1 test e2e/assess/*.ts
                    """
                }
            }
        }
        stage('provision - prod') {
            steps {
                timeout(5) {
                    script {
                        withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                            try {
                                sh """
                                export ARM_CLIENT_ID=$AZURE_CLIENT_ID
                                export ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET
                                export ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID
                                export ARM_TENANT_ID=$AZURE_TENANT_ID
                                terraform apply -auto-approve -var 'location=$location' -var 'initials=$initials' -var 'environment=production' -var 'servername=Prod-01'
                                """
                            } catch (Exception e) {
                                echo 'Terraform refresh failed, deleting state'
                                sh 'rm -rf terraform.tfstate'
                                currentBuild.result = 'FAILURE'
                                error('Aborting the build.')
                            }
                        }
                    }
                }
            }
        }
        stage('sleeping - prod') {
            steps {
                timeout(5) {
                    script {
                        waitUntil {
                            def r = sh returnStatus: true, script: "FQDN=\$(terraform output --raw fqdn); wget --retry-connrefused --tries=300 --waitretry=1 \$FQDN -O /dev/null"
                            return (r == 0)
                        }
                    }
                }
            }
        }
        stage('exercise - prod') {
            steps {
                timeout(5) {
                    sh """
                    FQDN=\$(terraform output --raw fqdn)
                    BASEURL=\$FQDN npx playwright@1.32.1 test e2e/protect/*.ts
                    """
                }
            }
        }
        stage('destroy') {
            steps {
                withCredentials([azureServicePrincipal('ContrastAzureSponsored')]) {
                    sh """
                    export ARM_CLIENT_ID=\$AZURE_CLIENT_ID
                    export ARM_CLIENT_SECRET=\$AZURE_CLIENT_SECRET
                    export ARM_SUBSCRIPTION_ID=\$AZURE_SUBSCRIPTION_ID
                    export ARM_TENANT_ID=\$AZURE_TENANT_ID
                    terraform destroy --auto-approve \
                        -var 'location=$location'
                    """
                }
            }
        }
    }
}
