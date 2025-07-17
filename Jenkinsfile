pipeline {
  agent any

  environment {
    IMAGE_NAME = 'dhineshkumar25/zulip'
    IMAGE_TAG = 'latest'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git 'https://github.com/m-dhineshkumar25/zulip.git'
      }
    }

    stage('Enable Corepack & Setup Yarn (if needed)') {
      steps {
        sh '''
          corepack enable || true
          corepack prepare yarn@stable --activate || true
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE_NAME:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-cred', variable: 'KUBECONFIG')]) {
          sh 'kubectl apply -f k8s/zulip-deployment.yaml'
        }
      }
    }
  }
}
