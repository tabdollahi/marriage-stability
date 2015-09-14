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
      # display_marital_statuses
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

class MarriageStabilityStats

  def initialize
  end

  def average_group_partner_rank(stable_matcher_instance, group)
    stable_matcher_instance.dating_game
    sum = 0
    persons = stable_matcher_instance.send(group)
    persons.each do |person|
      sum += (person.preferences.find_index(person.fiance)+1)
    end
    return sum.to_f/persons.length
  end

end



# test = StableMatching.new(RandomPersonsGenerator.new(participant_count: 4, initiator_gender: "female", receiver_gender: "male"))


# test.display_preferences
# test.dating_game
# test.display_marital_statuses

# stats = MarriageStabilityStats.new

# puts stats.average_group_partner_rank(test, :receivers)
# test.reverse_roles

# puts stats.average_group_partner_rank(test, :receivers)

