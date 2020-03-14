FROM mysql:8

# locale
RUN apt update
RUN apt install -y locales
RUN locale-gen ko_KR.UTF-8

# timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone