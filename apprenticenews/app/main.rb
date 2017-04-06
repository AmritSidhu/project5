require 'sinatra/base'
require 'pg'

class ApprenticeNews < Sinatra::Application

  configure :development do
    set :database_config, { dbname: 'apprenticenews' }
  end

  configure :production do
    set :database_config, production_database_config
  end

  def db_connection
    begin
      connection = PG.connect(settings.database_config)
      yield(connection)
    ensure
      connection.close
    end
  end

  def show_stuff
    db_connection do |conn|
      conn.exec('SELECT * FROM submissions ORDER BY id DESC')
    end
  end

  def submit(link, info)
    db_connection do |conn|
      conn.exec("INSERT INTO submissions (url, title) VALUES ('#{link}', '#{info}')")
    end
  end

  def update_comments(comment, number)
    db_connection do |conn|
      conn.exec("UPDATE submissions SET comments=('#{comment}') WHERE id=('#{number}')")
    end
  end

  post '/' do
    @name = []
    params.each do |key, value|
      @name << key << value
    end
    update_comments(@name[1], @name[0].to_i)
    erb :commented, locals: { title: "#{@name}"}
  end


  get '/' do
    @show_stuff = show_stuff
    erb :index, locals: { title: 'Apprentice News' }
  end

  get '/submit' do
    erb :submit
  end

  get '/submitted' do
    erb :index
  end

  post '/submit' do
    link = params[:link]
    info = params[:info]
    submit(link, info)
    erb :submitted, :locals => {'link' => link, 'info' => info}
  end

  if app_file == $0
    run!
  end

end
