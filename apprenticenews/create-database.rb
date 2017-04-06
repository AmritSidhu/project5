#!/usr/bin/env ruby

db_dir = '.postgres-data'
# Create the database (unless it's already been created)
system("initdb -D #{db_dir}") unless File.directory? db_dir

# Start the database server (unless it's already running)
system("pg_ctl -D #{db_dir} -l logs/postgres.log start") unless system("pg_ctl -D #{db_dir} status")

# (re)create the apprenticenews database
system('dropdb apprenticenews 2> /dev/null')
system('createdb apprenticenews')

