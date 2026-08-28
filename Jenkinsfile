pipeline {
	
	agent any

	stages {
		stage('Build') {
			steps {
				sh '''
					cd RettenTask-api/apollo-server
					docker build -t apollo-server:latest .
				'''
			}
		}

		stage('Deploy') {
			steps {
				sh '''
					docker stop apollo || true
					docker rm apollo || true
				
				docker run -d \
					--name apollo \
					--network monitoreo_net \
					-p 4000:4000
					apollo-server:latest
				'''
			}
		}
	}


}
