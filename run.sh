docker build -t upload .
docker run -d -it -p 80:80 --name upload upload
