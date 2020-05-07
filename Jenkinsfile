pipeline {
  agent any
  stages {
    stage('Ansible Init') {
      steps {
       sh "ansible-galaxy install -v -r requirements.yml"
      }
    }
        stage('Terraform Init') {
      steps {
            sh 'terraform init'
      }
    }
    stage('Ansible Run') {
      steps {
            sh 'ansible-playbook -v config.yml -i inventory'
      }
    }
  }
}
