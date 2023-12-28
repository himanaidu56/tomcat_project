node {
    stage('Checkout') {
        echo 'Checking out code from SCM'
        // Add SCM checkout steps here
    }

    stage('Build') {
        echo 'Building the application'
        // Add build steps here
    }

    stage('Test') {
        echo 'Running tests'
        // Add test steps here
    }

    stage('Deploy') {
        echo 'Deploying the application'
        // Add deployment steps here
    }
        }
    

