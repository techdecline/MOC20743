# Create-IIS for Windows Server 2016

# Pull IIS Image from Docker Hub
docker pull microsoft/iis

# Create Dockerfile for Custom IIS
new-item c:\build\Dockerfile -Force -ItemType File

$str = @"
FROM microsoft/iis
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
"@

$str | Out-File c:\build\Dockerfile -Encoding ascii

# Create new Container Image based on Dockerfile
docker build -t techdecline/iis-dockerfile c:\Build

# Run newly created container
docker run -d -p 80:80 techdecline/iis-dockerfile ping -t localhost