require './persons'
require './person_generators'
require 'pry'

class StableMatching

  attr_reader :initiators, :receivers

  def initialize(generator)
    @generator = generator
    @initiators = @generator.initiators
    @receivers = @generator.receivers
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
    @receivers.select {|receiver| !receiver.single?}.each do |engaged_receiver| 
      engaged_receiver.unengage
    end
  end

  def reverse_roles
    clear_marital_statuses
    @initiators = @generator.receivers
    @receivers = @generator.initiators
    dating_game
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

  def initialize(stable_matcher)
    @stable_matcher = stable_matcher
    @participant_count = @stable_matcher.initiators.length
    @stable_matcher.dating_game
  end

  def final_partner_ranks(group)
    final_partner_ranks = []
    persons = @stable_matcher.send(group)
    persons.each do |person|
      final_partner_ranks << person.preferences.find_index(person.fiance)+1
    end
    return final_partner_ranks
  end

  def average(array)
    return array.inject(:+).to_f/array.length
  end

  def group_satisifaction_score_one_hundred_scale(raw_group_average)
    raw_group_average/@participant_count*100
  end

  def percentage_diff(num_one, num_two)
    (num_one - num_two)/num_two*100
  end

  def improved_receiver_score
    # original_receiver_partner_ranks = average_group_partner_rank(:receivers)
    # @stable_matcher.reverse_roles
    # (average_group_partner_rank(:initiators) - original_receiver_score)/original_receiver_score*-100
    return 0
  end

end

class MarriageStatsRunner

  def initialize(participant_count, runs_count)
    @participant_count = participant_count
    @runs_count = runs_count
  end

  def generate_stats
    initiator_receiver_diff_aggregator = 0
    receiver_diff_aggregator = 0
    @runs_count.times do 
      randomPersons = RandomPersonsGenerator.new({participant_count: @participant_count})
      stable_matcher = StableMatching.new(randomPersons)
      stats = MarriageStabilityStats.new(stable_matcher)
      initiator_receiver_diff_aggregator += stats.average_difference_group_scores(:receivers, :initiators)
      receiver_diff_aggregator += stats.improved_receiver_score
    end
    puts initiator_receiver_diff_aggregator/@runs_count
    puts receiver_diff_aggregator/@runs_count
  end

end

# test = MarriageStatsRunner.new(1000, 100)
# test.generate_stats



