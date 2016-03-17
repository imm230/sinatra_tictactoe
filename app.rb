require 'sinatra'
require 'pry'

enable :sessions

helpers do
	def player_move(box)
		# Mark chosen tile as human
		hash = session[:tiles]
		hash[box.to_i] = "human"
		session[:tiles] = hash

		#Check if win
		win_check
	end

	def computer_move
		# Randomly select tile from the blank ones
		open = session[:tiles].select{|key, hash| hash == "blank" }
		box = open.keys.sample.to_i

		# Mark as computer
		hash = session[:tiles]
		hash[box.to_i] = "computer"
		session[:tiles] = hash

		# Check if win
		win_check
	end

	def win_check
		if human_win?
			halt erb :win
		elsif computer_win?
			halt erb :lose
		elsif cats_game?
			halt erb :cats_game
		end
	end

	def human_win?
		# Probably a better way to do this if I had time
		session[:tiles][1] == "human" && session[:tiles][2] == "human" && session[:tiles][3] == "human" ||
			session[:tiles][4] == "human" && session[:tiles][5] == "human" && session[:tiles][6] == "human" ||
			session[:tiles][7] == "human" && session[:tiles][8] == "human" && session[:tiles][9] == "human" ||
			session[:tiles][1] == "human" && session[:tiles][5] == "human" && session[:tiles][9] == "human" ||
			session[:tiles][7] == "human" && session[:tiles][5] == "human" && session[:tiles][3] == "human" ||
			session[:tiles][1] == "human" && session[:tiles][4] == "human" && session[:tiles][7] == "human" ||
			session[:tiles][2] == "human" && session[:tiles][5] == "human" && session[:tiles][8] == "human" ||
			session[:tiles][3] == "human" && session[:tiles][6] == "human" && session[:tiles][9] == "human"
	end

	def computer_win?
		# Probably a better way to do this if I had time
		session[:tiles][1] == "computer" && session[:tiles][2] == "computer" && session[:tiles][3] == "computer" ||
			session[:tiles][4] == "computer" && session[:tiles][5] == "computer" && session[:tiles][6] == "computer" ||
			session[:tiles][7] == "computer" && session[:tiles][8] == "computer" && session[:tiles][9] == "computer" ||
			session[:tiles][1] == "computer" && session[:tiles][5] == "computer" && session[:tiles][9] == "computer" ||
			session[:tiles][7] == "computer" && session[:tiles][5] == "computer" && session[:tiles][3] == "computer" ||
			session[:tiles][1] == "computer" && session[:tiles][4] == "computer" && session[:tiles][7] == "computer" ||
			session[:tiles][2] == "computer" && session[:tiles][5] == "computer" && session[:tiles][8] == "computer" ||
			session[:tiles][3] == "computer" && session[:tiles][6] == "computer" && session[:tiles][9] == "computer"
	end

	def cats_game?
		session[:tiles].select{|key, hash| hash == "blank" }.length == 0
	end
end

get '/' do
	session[:mode] = 1 if session[:mode].nil? 	# start with easy mode
	session[:tiles] = Hash[1 => 'blank', 
						   2 => 'blank',
						   3 => 'blank',
						   4 => 'blank',
						   5 => 'blank',
						   6 => 'blank',
						   7 => 'blank',
						   8 => 'blank',
						   9 => 'blank']

  	erb :index
end

get '/mode/:mode' do |mode|
	session[:mode] = mode.to_i
	redirect '/'
end

get '/:box' do |box|
	# in some browsers it looks for the favicon and turns it into 0
	unless box == 'favicon.ico'

		player_move(box)

		session[:mode].to_i.times do
			computer_move
		end

		@tiles = session[:tiles]
		erb :index
	end
end