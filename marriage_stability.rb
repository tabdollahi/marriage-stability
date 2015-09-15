require './persons'
require './person_generators'
require 'pry'

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

  def clear_marital_statuses
    @receivers.each {|receiver| receiver.unengage(receiver.fiance)}
  end

  def display_preferences
    puts "Initiator preferences"
    display_preferences_helper(@initiators)
    puts "*"*80
    puts "Receiver preferences"
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

  def initialize #(runs_count, participant_count)
    # @participant_count = participant_count
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


  def percentage_difference_group_scores(stable_matcher_instance)
    (average_group_partner_rank(stable_matcher_instance, :receivers) - average_group_partner_rank(stable_matcher_instance, :initiators))/average_group_partner_rank(stable_matcher_instance, :initiators)*100
  end


  def generate_stats

  end

end



test = StableMatching.new(RandomPersonsGenerator.new(participant_count: 5, initiator_gender: "male", receiver_gender: "female"))


test.display_preferences
# puts test.dating_game
# test.display_marital_statuses

stats = MarriageStabilityStats.new

# puts "***Original Test***"
# puts "original test receivers' score as receivers"
# puts stats.average_group_partner_rank(test, :receivers)
# puts "original test initiators' score as initiators"
# puts stats.average_group_partner_rank(test, :initiators)

# puts "&"*80
# puts "Reverse Test"

# test.clear_marital_statuses

# reverse_test = StableMatching.new(SpecificPersonsGenerator.new(test.receivers, test.initiators))

# reverse_test.display_preferences
# puts reverse_test.dating_game
# reverse_test.display_marital_statuses

# random_test = StableMatching.new(RandomPersonsGenerator.new(participant_count: 5, initiator_gender: "female", receiver_gender: "male"))

# puts "***Reversed Test***"
# puts "original test receivers' score as initiators"
# puts stats.average_group_partner_rank(reverse_test, :initiators)
# puts "original test initiator's score as receivers"
# puts stats.average_group_partner_rank(reverse_test, :receivers)


# puts "Random Test"
# puts stats.average_group_partner_rank(random_test, :receivers)
# puts stats.average_group_partner_rank(random_test, :initiators)

p stats.percentage_difference_group_scores(test)



