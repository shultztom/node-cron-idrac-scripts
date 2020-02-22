
FROM tks23/centos-7-node-base:latest

# Install ipmitools
USER root:root
RUN yum install -y ipmitool
USER 1001:0

# Create app directory
WORKDIR /home/node
COPY .nvmrc /home/node/.nvmrc

# Install Node.js
SHELL ["/bin/bash", "--login", "-c"]
RUN nvm install
RUN nvm use

# Install Yarn
RUN npm i -g yarn

# Install app dependencies
COPY package.json yarn.lock ./

RUN yarn install --production
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

CMD yarn start