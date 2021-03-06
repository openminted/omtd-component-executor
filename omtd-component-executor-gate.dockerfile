FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

#ENV LANG C.UTF-8

# Install java.
# -- -- --- - -- -- -- --- - -- 
RUN apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common && add-apt-repository ppa:webupd8team/java -y && apt-get update
RUN (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && apt-get install -y oracle-java8-installer oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

# Install Groovy.
RUN apt-get update && apt-get install -y \
curl \
unzip \
zip

RUN curl -s get.sdkman.io | bash
RUN /bin/bash -c  "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install groovy"

ENV PATH $PATH:/root/.sdkman/candidates/groovy/current/bin

# Install omtd-component-executor. 
# -- -- --- - -- -- -- --- - -- 
# Create target dir.
RUN mkdir /opt/omtd-component-executor/
# Copy everything to target dir.
COPY . /opt/omtd-component-executor/

# Copy GATE executor script to /usr/bin/
COPY ./scripts/Linux_runGATE.sh /usr/bin/

# Set working dir. 
WORKDIR /opt/omtd-component-executor/scripts/

# -- -- --- - -- -- -- --- - -- 


