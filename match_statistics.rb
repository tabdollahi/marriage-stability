require "./person_generators"
require "./stable_matcher"

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
      final_partner_ranks << group_satisifaction_score_one_hundred_scale(person.preferences.find_index(person.fiance)+1)
    end
    return final_partner_ranks
  end

  def average(array)
    return array.inject(:+)/array.length
  end

  def average_group_score(group)
    average(final_partner_ranks(group))
  end

  def group_satisifaction_score_one_hundred_scale(raw_rank)
    raw_rank.to_f/@participant_count*100
  end

  def percentage_change(num_one, num_two)
    (num_one - num_two)/num_two*100
  end

  def group_sat_score_diff
    average_group_score(:receivers)-average_group_score(:initiators)
  end

  def improved_receiver_score
    original_receiver_partner_ranks = final_partner_ranks(:receivers)
    @stable_matcher.reverse_roles
    new_receiver_partner_ranks = final_partner_ranks(:initiators)
    # return original_receiver_partner_ranks.zip(new_receiver_partner_ranks).map {|x,y| x-y }
    return average(original_receiver_partner_ranks.zip(new_receiver_partner_ranks).map {|x,y| percentage_change(y,x)})
  end

  def average_improvement_satisfaction_score
    average(improved_receiver_score)
  end

  def percent_diff_group_sat_scores  
    return percentage_diff(average_group_score(:receivers), average_group_score(:initiators))
  end

end

class StatisticsRunner

  def initialize(participant_count, runs_count)
    @participant_count = participant_count
    @runs_count = runs_count
  end

  def generate_stats
    initiator_group_average = 0
    receiver_group_average = 0
    receiver_diff_aggregator = 0
    initiator_receiver_diff_aggregator = 0
    @runs_count.times do 
      randomPersons = RandomPersonsGenerator.new({participant_count: @participant_count})
      stable_matcher = StableMatcher.new(randomPersons)
      stats = MatchStatistics.new(stable_matcher)
      initiator_group_average += stats.average_group_score(:initiators)
      receiver_group_average += stats.average_group_score(:receivers)
      initiator_receiver_diff_aggregator += stats.group_sat_score_diff
      # initiator_receiver_diff_aggregator += stats.percent_diff_group_sat_scores
      receiver_diff_aggregator += stats.improved_receiver_score
    end
    # puts initiator_receiver_diff_aggregator.to_f/@runs_count
    puts "Initiator group average: #{initiator_group_average/@runs_count}"
    puts "Receiver group average: #{receiver_group_average/@runs_count}"
    puts "Difference: #{initiator_receiver_diff_aggregator/@runs_count}"
    puts "Percentage difference in receiver score: #{receiver_diff_aggregator/@runs_count}"

  end

end

participant_count = ARGV[0].to_i
runs_count = ARGV[1].to_i

puts "n = #{participant_count}"
puts "m = #{runs_count}"


new_stats = StatisticsRunner.new(participant_count, runs_count)
new_stats.generate_stats

# test = MatchStatistics.new(StableMatcher.new(RandomPersonsGenerator.new({participant_count: 100})))
# puts test.percent_diff_group_sat_scores
# initiator_average = test.average_group_score(:initiators)
# receiver_average = test.average_group_score(:receivers)

# puts initiator_average
# puts receiver_average

# puts test.group_satisifaction_score_one_hundred_scale(initiator_average)
# puts test.group_satisifaction_score_one_hundred_scale(receiver_average)

# puts test.improved_receiver_score


# test = StatsRunner.new(1000, 100)
# test.generate_stats