FROM ubuntu:latest

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 80

RUN apt-get update && apt install -y awscli tree
RUN apt-get install nginx -y

# CMD aws s3 cp s3://danhdd1-s3-storage/index.html /var/www/html/index.html
COPY index.html /var/www/html/

CMD ["nginx", "-g", "daemon off;"]
