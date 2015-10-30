class MatchStatistics

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

  def average_group_score(group)
    average(final_partner_ranks(group))
  end

  def group_satisifaction_score_one_hundred_scale(raw_group_average)
    raw_group_average/@participant_count*100
  end

  def percentage_diff(num_one, num_two)
    (num_one - num_two)/num_two*100
  end

  def improved_receiver_score
    original_receiver_partner_ranks = final_partner_ranks(:receivers)
    @stable_matcher.reverse_roles
    new_receiver_partner_ranks = final_partner_ranks(:initiators)
    return original_receiver_partner_ranks.zip(new_receiver_partner_ranks).map {|x,y| x-y }
  end

  def average_improvement_satisfaction_score
    group_satisifaction_score_one_hundred_scale(average(improved_receiver_score))
  end

end

class StatisticsRunner

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

# test = StatsRunner.new(1000, 100)
# test.generate_stats