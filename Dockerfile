FROM alpine:3.12 as base
RUN sed -i -e 's/^\(.*\)v3.12\/main/@edge-testing \1edge\/testing\n&/' /etc/apk/repositories

RUN apk add --no-cache --virtual ruby-dependencies \
      ncurses readline sqlite sqlite-libs yaml tzdata \
 && apk add --no-cache ry@edge-testing

RUN adduser -D -g app app
ENV RY_PREFIX /home/app/.local
ENV PATH=$RY_PREFIX/lib/ry/current/bin:$PATH

###
FROM base as build

RUN apk add --no-cache sqlite-dev build-base \
 && apk add --no-cache ruby-build@edge-testing

USER app
RUN ry install 2.6.6
RUN gem install --no-document gemstash

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
