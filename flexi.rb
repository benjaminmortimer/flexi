require 'csv'
require 'sinatra'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"


def log(filename, in_out, date, time)
	log = CSV.read(filename)
	if in_out == "in"
		log << [date, time]
	elsif in_out == "out"
		log[-1] << time
	end
	CSV.open(filename, 'w') do
		|csv| log.each do |row_array|
			csv << row_array
		end
	end
end

def show(filename)
	CSV.read(filename)
end

get '/' do 
	erb :index, :locals => {:done => false}
end

post '/done' do
	log('log.csv', params['in_out'], params['date'], params['time'])
	erb :index, :locals => {:done => true}
end

get '/show' do
	erb :show, :locals => {:times => show('log.csv')}
end
