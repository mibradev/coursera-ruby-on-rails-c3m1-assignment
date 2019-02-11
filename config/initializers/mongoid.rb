# Be sure to restart your server when you modify this file.

Mongoid.load!("#{Rails.root}/config/mongoid.yml")
Rails.application.config.generators { |g| g.orm :mongoid }
