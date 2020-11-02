FROM ruby:2.4
RUN apt-get update -qq && apt-get install -y build-essential
RUN mkdir /usr/local/src/activerecord-creating_foreign_keys
WORKDIR /usr/local/src/activerecord-creating_foreign_keys
