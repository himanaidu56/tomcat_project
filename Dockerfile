pipeline {
    agent {label 'tomcat'}
    
    environment {
        AWS_ACCOUNT_ID="164265229204"
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="ecr2"
        IMAGE_TAG="v1"
        REPOSITORY_URI = "164265229204.dkr.ecr.ap-south-1.amazonaws.com/ecr2"
    }
   
    stages {
       
        stage('Git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/artisantek/java-example.git'     
            }
        } 
   
    // Building Docker images
    stage('Docker build') {
      steps{
            script {
                    sh "docker build -t ${REPOSITORY_URI}:${IMAGE_TAG} ."
        }
      }
    }     
         stage('Logging into AWS ECR') {
            steps {
                script {
                        sh """aws ecr get-login-password \
    --region ${AWS_DEFAULT_REGION} \
| docker login \
    --username AWS \
    --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                }
                 
            }
        }
        
        // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""
         }
        }
      }
      
      stage ('deploy to docker server'){
          steps{
                script{
                        sh "docker run -d -p 8000:8080 ${REPOSITORY_URI}:${IMAGE_TAG}" 
                }
          }
      }
      
    }
}
