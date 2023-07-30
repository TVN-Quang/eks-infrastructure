#!/usr/bin/env groovy

// Configure using terraform and using "masters" branch
@Library('terraform@main') _
def app

// Entry point into
pipeline {
    agent none

    tools {
        terraform 'terraform-v1.3.6'
    }

    options {
        ansiColor('xterm')
    }

    environment {
        BRANCH_NAME = ''
    }

    stages {
        stage('Prerun') {
            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    echo "branch name $GIT_BRANCH"
                    BRANCH_NAME = "$GIT_BRANCH"
                    (project, approver, otherArgs, outputPlanFile, varFiles) = terraform.preRun()
                }
            }
        }

        stage('Terraform init Uat') {
            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    terraform.init("uat")
                }
            }
        }

        stage('Terraform Plan UAT') {
            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    terraform.replaceTextInFile("\${var.name}-eks-node-group", "\${var.name}", ".terraform/modules/base.cluster/modules/eks-managed-node-group/main.tf")
                    terraform.plan(otherArgs, outputPlanFile, "aws-uat", varFiles, "uat")
                }
            }
        }

        stage('Approved UAT') {
            parallel {
                stage('Waiting for approve') {
                    agent {
                        label 'jenkins_slave'
                    }
                    options {
                        timeout(time: 48, unit: 'HOURS')
                    }
                    steps {
                        script {
                            terraform.waitingApprove("UAT")
                        }
                    }
                }

                stage('Send notification') {
                    agent none
                    steps {
                        script {
                            terraform.sendNotification(project, approver, "uat")
                        }
                    }
                }
            }
        }

        stage('Terraform Apply UAT') {
            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    terraform.apply(outputPlanFile, "aws-uat")
                }
            }
        }

        stage('Terraform init Prod') {
            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    terraform.init("prod")
                }
            }
        }

        stage('Terraform Plan Prod') {
            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    terraform.replaceTextInFile("\${var.name}-eks-node-group", "\${var.name}", ".terraform/modules/base.cluster/modules/eks-managed-node-group/main.tf")
                    terraform.plan(otherArgs, outputPlanFile, "aws-prod", varFiles, "prod")
                }
            }
        }

        stage('Approved Production') {
            parallel {
                stage('Waiting for approve') {
                    agent {
                        label 'jenkins_slave'
                    }
                    options {
                        timeout(time: 48, unit: 'HOURS')
                    }
                    steps {
                        script {
                            terraform.waitingApprove("Production")
                        }
                    }
                }
                stage('Send notification') {
                    agent none
                    steps {
                        script {
                            terraform.sendNotification(project, approver, "production")
                        }
                    }
                }
            }
        }

        stage('Terraform Apply Prod') {
            // when {
            //     expression { BRANCH_NAME.contains('main') }
            // }

            agent {
                label 'jenkins_slave'
            }

            steps {
                script {
                    terraform.apply(outputPlanFile, "aws-prod")
                }
            }
        }
    }
}
