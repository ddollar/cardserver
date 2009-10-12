module CardServer; end

Dir[File.join(File.dirname(__FILE__), '{ext,lib}', '**', '*.rb')].each do |file|
  require file
end

load 'application.rb'

run CardServer::Application.new
