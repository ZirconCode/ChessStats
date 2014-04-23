
require_relative 'config.rb'
require_relative 'analyse.rb'

require 'nokogiri'
require 'open-uri'


desc 'Grab chess.emrald Data'
task :update_puzzles do |t|
	doc = Nokogiri::HTML(open(Env[:puzzle_profile]))
	File.open(Env[:storage_profile_path]+Time.now.to_i.to_s, "w") do |f|
		f.write doc.xpath('//td[@class=\'content\']')
	end
end

desc 'Grab Chess Games'
task :update_games do |t|
	files = FileList.new()
	files.include(Env[:chess_games]+"*")
	FileUtils.cp(files,Env[:storage_games_path])
end

desc "Grab All Data"
multitask :update => [:update_puzzles, :update_games] do |t|
	# =)
end


desc "Interpret Data"
task :examine do |t|
	examine
end

desc "Run StockFish on Games"
task :stockfish do |t|
	runStockfish
end

desc "Create Anki Deck from StockFish Suggestions"
task :anki do |t|
	# TODO
end