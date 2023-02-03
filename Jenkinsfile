pipeline{
    
    agent any 
    
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/dmancloud/demo-counter-app.git'
                }
            }
        }
        stage('UNIT testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'sonarqube-api') {
                        
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube-api'
                    }
                }
            }
            stage('Docker Build & Push') {
                steps {
                    script {
                        withDockerRegistry(credentialsId: '0f55c298-092d-46b4-bbe4-6bcd56c5d9ac') {
                            sh "docker build -t dmdeepfactor/dm-springboot-example:1.0 ."
                            sh "docker push dmdeepfactor/dm-springboot-example:1.0"
                    }
                 }
             }
            }
        }
        
}
