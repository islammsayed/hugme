FROM ubuntu

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -q -y install ruby ruby-dev build-essential libpq-dev libmysqlclient-dev

ENV DEVISE_SECRET_KEY="4326b01f3ff3258f0c601652c77213f5b73656fb148551898dc93d9aa629305845c16c1792f06a32e84f19ec6f75e98bf8213406004096fa1b5986506ae48b3e" \
    RAILS_ENV="production" \
    SECRET_KEY_BASE="$(openssl rand -base64 32)"

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc \
    && gem install bundler
RUN mkdir -p /app
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install --without development test --jobs 4
COPY . /app/
RUN bundle exec rake assets:precompile

EXPOSE 3000