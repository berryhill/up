FROM ubuntu:latest

# Install Ubuntu Dependencies
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget bzr ca-certificates nodejs npm && \
  rm -rf /var/lib/apt/lists/*

# Install Go1.9
RUN wget -O $HOME/go1.9.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz
RUN tar -C /usr/local -xf $HOME/go1.9.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
RUN mkdir $HOME/gopath
ENV PATH="/root/go/bin:${PATH}"
RUN go version
RUN go env

# Install Up Dependencies
RUN go get -u github.com/golang/dep/cmd/dep
RUN go get github.com/apex/up
RUN cd /root/go/src/github.com/apex/up && dep ensure
RUN cd /root/go/src/github.com/apex/up && make install.deps; exit 0
RUN cd /root/go/src/github.com/apex/up && make build
RUN cd /root/go/src/github.com/apex/up && make test; exit 0
