FROM debian:jessie

RUN apt-get update -y && apt-get install -y cowsay

ENV PATH $PATH:/usr/games

CMD ["cowsay", "Hi"]
