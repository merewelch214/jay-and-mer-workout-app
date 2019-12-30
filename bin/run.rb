require_relative '../config/environment'

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

cli = CLI.new
cli.start
