#!/bin/bash
bash -l
source /usr/local/rvm/scripts/rvm
rvm @global do gem install bundler
git clone https://github.com/Levara/ImageClinic.git ~/app
rvm @global do gem install bundler
cd ~/app
bundle install
rails db:environment:set RAILS_ENV=development
bundle exec rake db:setup


