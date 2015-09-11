FROM google/nodejs

RUN apt-get update -y && apt-get install --no-install-recommends -y -q git ssh

RUN npm install -g pm2


WORKDIR /app

RUN git clone https://github.com/mstrandgren/name-generator.git .

WORKDIR /app/be
RUN npm install

EXPOSE 8000

ENTRYPOINT ["pm2", "start", "-i", "0", "--no-daemon", "app.coffee"]