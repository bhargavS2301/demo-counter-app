pipeline {
  agent any
  stages {
    stage('Git Checkout') {
      steps {
        script {
          git branch: 'main', url: 'https://github.com/dmancloud/demo-counter-app.git'
        }

      }
    }

    stage('UNIT testing') {
      steps {
        script {
          sh 'mvn test'
        }

      }
    }

    stage('Integration testing') {
      steps {
        script {
          sh 'mvn verify -DskipUnitTests'
        }

      }
    }

    stage('Maven build') {
      steps {
        script {
          sh 'mvn clean install'
        }

      }
    }

    stage('Docker Build & Push') {
      steps {
        script {
          withDockerRegistry(credentialsId: 'dockerhub') {
            sh "docker build -t dmancloud/demo-counter-app:1.1.0-$BUILD_ID ."
            sh "docker push dmancloud/demo-counter-app:1.1.0-$BUILD_ID"
          }
        }

      }
    }

  }
  tools {
    jdk 'Java11'
    maven 'maven3'
  }
}