FROM google/nodejs

RUN apt-get update -y && apt-get install --no-install-recommends -y -q git ssh

RUN npm install -g pm2


WORKDIR /app

RUN mkdir /root/.ssh
ADD id_rsa /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

RUN git clone git@bitbucket.org:mstrandgren/name-generator.git .

RUN rm -Rf /root/.ssh/id_rsa

WORKDIR /app/be
RUN npm install

EXPOSE 8000

ENTRYPOINT ["pm2", "start", "-i", "0", "--no-daemon", "app.coffee"]