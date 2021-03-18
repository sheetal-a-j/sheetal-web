# frozen_string_literal: true

require 'csv'
require 'json'
deliveries = CSV.parse(File.read('deliveries.csv'), headers: true)
match = CSV.parse(File.read('matches.csv'), headers: true)
umpire = CSV.parse(File.read('umpires.csv'), headers: true)

# Mapping of Rising pune supergiants to rising pune supergiant."
deliveries['batting_team'] = deliveries['batting_team'].map do |e|
  if e == 'Rising Pune Supergiants'
    'Rising Pune Supergiant'
  else
    e
  end
end
# First question to find the total runs scored by each team over the season
# t_run dictionary contain all the teams as key and their total_runs as value

total_run_per_team = Hash.new(0) # using default value 0 for each team
deliveries.each do |row|
  total_run_per_team[row['batting_team']] += row['total_runs'].to_i
end

File.write('./data1.json', JSON.dump(total_run_per_team))

# second question total score of each player in rcb team
# rcb dict contain all the players as key and their total_run as value

rcb_players_total_run = Hash.new(0)
deliveries.each do |row|
  if row['batting_team'] == 'Royal Challengers Bangalore'
    rcb_players_total_run[row['batsman']] += row['total_runs'].to_i
  end
end
rcb_players_total_run = Hash[rcb_players_total_run.sort_by { |_key, value| -value } [0..5]]

File.write('data2.json', JSON.dump(rcb_players_total_run))



# third question of number of umpires for each country

umpires_per_nation = Hash.new(0)
umpire.each do |row|
  umpires_per_nation[row['Nationality']] += 1 if row['Nationality'].strip != 'India'
end


File.write('data3.json', JSON.dump(umpires_per_nation))
# 4th question

season = match['season'].uniq.sort
season = season.map(&:to_i)

# t_run from question1 is used , where all the team names are stored as key
team = []
total_run_per_team.each_key do |key|
  team << key
end
# games_played_by_season_by_team containes team as key and array as value.
# that array includes total run scored by that team per season

games_played_by_season_by_team = Hash.new(0)
team.each do |t|
  games_played_by_season_by_team[t] = []
  season.each do |s|
    sum = 0
    match.each do |row|
      sum += 1 if (row['season'].to_i == s) && ((row['team1'] == t) || (row['team2'] == t))
    end
    games_played_by_season_by_team[t] << sum
  end
end
 

File.write('data4.json', JSON.dump(games_played_by_season_by_team))

