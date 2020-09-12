FROM alpine:3.12 as base

RUN apk add --no-cache --virtual ruby-dependencies \
      ncurses readline sqlite sqlite-libs yaml tzdata \
 && apk add --no-cache ruby-full

RUN adduser -D -g app app
ENV PATH=$PATH:/home/app/.gem/ruby/2.7.0/bin
ENV GEM_HOME ~app/.gems

###
FROM base as build

RUN apk add --no-cache sqlite-dev build-base \
 && apk add --no-cache ruby-dev

USER app
RUN gem install --user-install --no-document gemstash

###
FROM base

ENV GEMSTASH_HOME /home/app/gemstash

COPY --chown=app --from=build /home/app/ /home/app/
RUN mkdir $GEMSTASH_HOME \
 && chown -R app:app $GEMSTASH_HOME
COPY config.yml /home/app/.gemstash/config.yml

WORKDIR $GEMSTASH_HOME

USER app

EXPOSE 9292

VOLUME ["$GEMSTASH_HOME"]
CMD ["gemstash", "start", "--no-daemonize"]
