FROM centos:7

# Install ipmitools
USER root:root
RUN yum install -y ipmitool

# Change shell to bash
SHELL ["/bin/bash", "-c"]

# Set up non-root user
ENV HOME=/home/node
RUN umask 002 \
    && mkdir -p ${HOME} && chmod 0770 ${HOME} \
    && useradd node \
    --home-dir ${HOME} -M \
    --uid 1001 \
    --no-user-group \
    --gid 0

# Switch to non-root user
USER 1001:0

# Create bash_profile
RUN touch ${HOME}/.bash_profile

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

# Create app directory
WORKDIR /home/node
COPY .nvmrc /home/node/.nvmrc

# Install Node.js
SHELL ["/bin/bash", "--login", "-c"]
RUN nvm install
RUN nvm use

# Install app dependencies
COPY package.json package-lock.json ./

RUN npm install --production

# Bundle app source
COPY . .

CMD npm start