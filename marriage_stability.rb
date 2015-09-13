require './persons'
require './person_generators'

class StableMatching

  attr_reader :initiators, :receivers

  def initialize(generator)
    @initiators = generator.initiators
    @receivers = generator.receivers
  end

  def dating_game
    while @initiators.any? { |initiator| initiator.single? }
      play_round
    end
  end

  def play_round
    @initiators.select {|x| x.single?}.each do |current_suitor|
      current_suitor.propose_to_next_preferred
    end
  end

  def display_preferences
    display_helper(@initiators)
    display_helper(@receivers)
  end

  def display_engagements
    puts "*"*80
    puts "Engagements"
    @receivers.each do |receiver|
      if receiver.fiance != nil
        puts "#{receiver.name}: #{receiver.fiance.name}"
      end
    end
  end

  private

  def display_helper(group)
    group.each do |person|
      puts "These are #{person.name}'s preferences:"
      person.preferences.each {|person| puts person.name}
      puts "*"*80
    end
  end

end



# test = StableMatching.new(RandomPersonsGenerator.new(4))


# test.display_preferences
# test.dating_game
# test.display_engagements
