require 'pg'
require 'etc'

class Database
  def self.init()
    uri = URI.parse ENV.fetch('DATABASE_URL', "postgres://#{Etc.getlogin}@localhost/apprenticenews")
    conn = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)

    unless submissions_table_created(conn)
      puts 'No submissions found, creating some example ones'

      conn.exec "CREATE TABLE submissions (id bigserial primary key, url text not null, title text not null)"
      submissions = [
        {url:'https://www.gov.uk', title: 'Really cool website where you can interact with the UK Government'},
        {url:'https://duckduckgo.com', title: 'The search engine that doesn\'\'t track you'},
        {url:'https://github.com/alphagov/apprentice-news', title: 'The most awesome link aggregation site ever'},
      ]

      submissions.each do |submission|
        conn.exec "INSERT INTO submissions (url, title) VALUES ('#{submission[:url]}','#{submission[:title]}')"
      end
    end
  end

  def self.submissions_table_created(conn)
    conn.exec "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'submissions')" do |result|
      return result.any? { |row| row['exists'] == 't' }
    end
  end

end
