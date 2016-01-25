FROM ubuntu

RUN apt-get install -y git

RUN git clone https://sbarb@bitbucket.org/sbarb/email.git /data

RUN bash /data/init/install.sh -D
