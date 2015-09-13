require './persons'
require './person_generators'

class StableMatching

  attr_reader :initiators, :receivers

  def initialize(generator)
    @initiators = generator.initiators
    @receivers = generator.receivers
  end

  def dating_game
    while any_singles?
      play_round
      display_marital_statuses
    end
  end

  def play_round
    single_persons(@initiators).each do |current_suitor|
      current_suitor.propose_to_next_preferred
    end
  end

  def display_preferences
    display_preferences_helper(@initiators)
    display_preferences_helper(@receivers)
  end

  def display_marital_statuses
    puts "*"*80
    puts "Marital Statuses"
    puts "*"*80
    @receivers.select {|x| !x.single?}.each do |receiver|
      puts "#{receiver.name}: #{receiver.fiance.name}"
    end
    display_singles
  end

  private

  def any_singles?
    @initiators.any? { |initiator| initiator.single? }
  end

  def single_persons(group)
    group.select {|x| x.single?}
  end

  def display_preferences_helper(group)
    group.each do |person|
      puts "These are #{person.name}'s preferences:"
      person.preferences.each {|person| puts person.name}
      puts "*"*80
    end
  end

  def display_singles_helper(group)
    single_persons(group).each do |person|
      puts "#{person.name}"
    end
  end

  def display_singles
    if any_singles?
      puts "Singles:"
      display_singles_helper(@initiators)
      display_singles_helper(@receivers)
    end
  end
end



test = StableMatching.new(RandomPersonsGenerator.new(4))


test.display_preferences
test.dating_game

