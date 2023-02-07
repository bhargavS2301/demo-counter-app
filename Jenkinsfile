pipeline{
    
    agent any 
    environment {
	    
	    COSIGN_PUBLIC_KEY=credentials('cosign-public-key')
	    COSIGN_PASSWORD=credentials('cosign-password')
    }    
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
                        withDockerRegistry(credentialsId: 'dockerhub') {
                            sh "docker build -t dmancloud/demo-counter-app:1.0.0-$BUILD_ID ."
                            sh "docker push dmancloud/demo-counter-app:1.0.0-$BUILD_ID"
                    }
                 }
             }
            }
        
	      stages {
    		stage('sign the container image') {
      			steps {
        			sh 'cosign version'
        			sh 'cosign sign --key $COSIGN_PRIVATE_KEY dmancloud/demo-counter-app:1.0.0-$BUILD_ID'    						    }
    			      }
  		    }

		stage("Setting Deepfactor RunToken") {
			steps {
				script {
					env.DF_RUN_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyaWQiOiJiY2JkNGU0YS1jYjIwLTQ0YTQtYmQ5Ni0zZTk3M2M3OGRlN2UiLCJ0b2tlbmlkIjoiN2ExNzAxZDEtMDdlYS00MDA3LWEzNjctZmYxMjU2NTM0MmFmIiwic3ViZG9tYWluIjoiZGYiLCJjdXN0b21lcmlkIjoiOWI1NWIwZDEtOGI3NC00NTQyLTgxYzMtZjJlNzU1N2NmZjQ3IiwidXNlcmxldmVsIjoiQ1VTVE9NRVIiLCJyb2xlaWQiOiJmZDRkYTNhNi1hOTFhLTRmOTQtYjM2ZS1hNWU1ZDY3NThiZDEiLCJyb2xlbmFtZSI6IkNfQURNSU4iLCJ0b2tlbl90eXBlIjoiREZfUlVOX1RPS0VOIiwiZXhwIjoxNzA2ODAxNTk4LCJpYXQiOjE2NzUyNjU1OTgsIm5iZiI6MTY3NTI2NTU5OCwicG9ydGFsVVJMIjoiZGVtby5kZXYuZGVlcGZhY3Rvci5hcHAiLCJjdXN0b21lclBvcnRhbFVSTCI6ImRmLmRlbW8uZGV2LmRlZXBmYWN0b3IuYXBwIiwicG9ydGFsQ0EiOiJNSUlGYXpDQ0ExT2dBd0lCQWdJUkFJSVF6N0RTUU9OWlJHUGd1Mk9DaXdBd0RRWUpLb1pJaHZjTkFRRUxCUUF3XG5UekVMTUFrR0ExVUVCaE1DVlZNeEtUQW5CZ05WQkFvVElFbHVkR1Z5Ym1WMElGTmxZM1Z5YVhSNUlGSmxjMlZoXG5jbU5vSUVkeWIzVndNUlV3RXdZRFZRUURFd3hKVTFKSElGSnZiM1FnV0RFd0hoY05NVFV3TmpBME1URXdORE00XG5XaGNOTXpVd05qQTBNVEV3TkRNNFdqQlBNUXN3Q1FZRFZRUUdFd0pWVXpFcE1DY0dBMVVFQ2hNZ1NXNTBaWEp1XG5aWFFnVTJWamRYSnBkSGtnVW1WelpXRnlZMmdnUjNKdmRYQXhGVEFUQmdOVkJBTVRERWxUVWtjZ1VtOXZkQ0JZXG5NVENDQWlJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dJUEFEQ0NBZ29DZ2dJQkFLM29KSFAwRkRmem01NHJWeWdjXG5oNzdjdDk4NGtJeHVQT1pYb0hqM2RjS2kvdlZxYnZZQVR5amIzbWlHYkVTVHRyRmovUlFTYTc4ZjB1b3hteUYrXG4wVE04dWtqMTNYbmZzN2ovRXZFaG1rdkJpb1p4YVVwbVpteVBmanh3djYwcElnYno1TURtZ0s3aVM0KzNtWDZVXG5BNS9UUjVkOG1VZ2pVK2c0cms4S2I0TXUwVWxYaklCMHR0b3YwRGlOZXdOd0lSdDE4akE4K28rdTNkcGpxK3NXXG5UOEtPRVV0K3p3dm8vN1YzTHZTeWUwcmdUQklsREhDTkF5bWc0Vk1rN0JQWjdobS9FTE5LakQrSm8yRlIzcXlIXG5CNVQwWTNIc0x1SnZXNWlCNFlsY05IbHNkdTg3a0dKNTV0dWttaThteGRBUTRRN2UyUkNPRnZ1Mzk2ajN4K1VDXG5CNWlQTmdpVjUrSTNsZzAyZFo3N0RuS3hIWnU4QS9sSkJkaUIzUVcwS3RaQjZhd0JkcFVLRDlqZjFiMFNIelV2XG5LQmRzMHBqQnFBbGtkMjVITjdyT3JGbGVhSjEvY3RhSnhRWkJLVDVaUHQwbTlTVEpFYWRhbzB4QUgwYWhtYlduXG5PbEZ1aGp1ZWZYS25FZ1Y0V2UwK1VYZ1ZDd09QamRBdkJiSStlMG9jUzNNRkV2ekc2dUJRRTN4RGszU3p5blRuXG5qaDhCQ05BdzFGdHhOclFIdXNFd01GeEl0NEk3bUtaOVlJcWlveW1DekxxOWd3UWJvb01EUWFIV0JmRWJ3cmJ3XG5xSHlHTzBhb1NDcUkzSGFhZHI4ZmFxVTlHWS9yT1BOazNzZ3JEUW9vLy9mYjRoVkMxQ0xRSjEzaGVmNFk1M0NJXG5yVTdtMllzNnh0MG5VVzcvdkdUMU0wTlBBZ01CQUFHalFqQkFNQTRHQTFVZER3RUIvd1FFQXdJQkJqQVBCZ05WXG5IUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSNXRGbm1lN2JsNUFGemdBaUl5QnBZOXVtYmJqQU5CZ2txXG5oa2lHOXcwQkFRc0ZBQU9DQWdFQVZSOVlxYnl5cUZEUURMSFlHbWtnSnlrSXJHRjFYSXB1K0lMbGFTL1Y5bFpMXG51Ymh6RUZuVElaZCs1MHh4KzdMU1lLMDVxQXZxRnlGV2hmRlFEbG5yenVCWjZickpGZStHblkrRWdQYms2WkdRXG4zQmViWWh0RjhHYVYwbnh2d3VvNzd4L1B5OWF1Si9HcHNNaXUvWDErbXZvaUJPdi8yWC9xa1NzaXNSY09qL0tLXG5ORnRZMlB3QnlWUzV1Q2JNaW9nemlVd3RoRHlDMys2V1Z3VzZMTHYzeExmSFRqdUN2akhJSW5Oemt0SENnS1E1XG5PUkF6STRKTVBKK0dzbFdZSGI0cGhvd2ltNTdpYXp0WE9vSndUZHdKeDRuTENnZE5iT2hkanNudnpxdkh1N1VyXG5Ua1hXU3RBbXpPVnl5Z2hxcFpYakZhSDNwTzNKTEYrbCsvK3NLQUl1dnRkN3UrTnhlNUFXMHdkZVJsTjhOd2RDXG5qTlBFbHB6Vm1iVXE0SlVhZ0VpdVREa0h6c3hIcEZLVks3cTQrNjNTTTFOOTVSMU5iZFdoc2NkQ2IrWkFKelZjXG5veWkzQjQzbmpUT1E1eU9mKzFDY2VXeEcxYlFWczVadWZwc01sanE0VWkwLzFsdmgrd2pDaFA0a3FLT0oycXhxXG40Umdxc2FoRFlWdlRIOXc3alhieUxlaU5kZDhYTTJ3OVUvdDd5MEZmLzl5aTBHRTQ0WmE0ckYyTE45ZDExVFBBXG5tUkd1blVIQmNuV0V2Z0pCUWw5bkpFaVUwWnNudmdjL3ViaFBnWFJSNFhxMzdaMGo0cjdnMVNnRUV6d3hBNTdkXG5lbXlQeGdjWXhuL2VSNDQvS0o0RUJzK2xWRFIzdmV5Sm0ra1hROTliMjEvK2poNVhvczFBblg1aUl0cmVHQ2M9In0.YxVDudkEA7FyjGTtOUmsZCcT1RRLpGxUYxlmiPexkzo"
				}
			}
		}


        
        stage('Deepfactor Static Scan') {
            steps {
                sh "dfctl scan dmancloud/demo-counter-app:1.0.0-$BUILD_ID"
            }
        }   
        }
        
}
