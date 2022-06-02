# docker-nginx-upload
Simple upload server using [nginx-upload-module](https://www.nginx.com/resources/wiki/modules/upload/).

### Usage
```bash
docker build -t upload .
docker run -d -it -p 80:80 --name upload upload

# upload file
curl -X POST -F file1=@file_path localhost:80/upload

# find the file
docker exec -it upload bash 
> cat upload/0000000001
```
