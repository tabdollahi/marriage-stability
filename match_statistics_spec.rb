require "./stable_matcher"
require "./match_statistics"

describe "MatchStatistics" do

  before :each do
    @william = Person.new("William")
    @robert = Person.new("Robert")
    @richard = Person.new("Richard")
    @anthony = Person.new("Anthony")
    @john = Person.new("John")

    @elizabeth = Person.new("Elizabeth", [@john, @william, @anthony, @richard, @robert])
    @jennifer = Person.new("Jennifer", [@robert, @william, @anthony, @richard, @john])
    @deborah = Person.new("Deborah", [@anthony, @william, @richard, @robert, @john])
    @dorothy = Person.new("Dorothy", [@robert, @john, @richard, @william, @anthony])
    @nancy = Person.new("Nancy", [@robert, @john, @richard, @anthony, @william])


    @william.preferences = [@deborah, @elizabeth, @dorothy, @nancy, @jennifer]
    @robert.preferences = [@dorothy, @deborah, @elizabeth, @nancy, @jennifer]
    @richard.preferences = [@jennifer, @dorothy, @elizabeth, @nancy, @deborah]
    @anthony.preferences = [@deborah, @jennifer, @elizabeth, @dorothy, @nancy]
    @john.preferences = [@deborah, @elizabeth, @nancy, @jennifer, @dorothy]

    initiators = [@william, @robert, @richard, @anthony, @john]
    receivers = [@elizabeth, @jennifer, @deborah, @dorothy, @nancy]

    @simulation = StableMatcher.new(SpecificPersonsGenerator.new(initiators, receivers))
    @stats_finder = MatchStatistics.new(@simulation)

  end

  describe "#final_partner_ranks" do
    it "returns an array of each member in a group's final partner rank" do
      expect(@stats_finder.final_partner_ranks(:initiators)).to be == ([4,1,1,1,2])
    end
  end

  describe "#average_group_score" do
    it "finds the average rank of the receivers' respective final partners" do
      expect(@stats_finder.average_group_score(:receivers)).to be == (2.4)
    end
    it "finds the average rank of the initiators' respective final partners" do
      expect(@stats_finder.average_group_score(:initiators)).to be == (1.8)
    end
  end

  describe "#group_satisifaction_score_one_hundred_scale" do
    it "finds the group satisifcation score on a scale of one to one hundred" do
      expect(@stats_finder.group_satisifaction_score_one_hundred_scale(2.4)).to be == (48.0)
      expect(@stats_finder.group_satisifaction_score_one_hundred_scale(1.8)).to be == (36.0)
    end
  end

  describe "#percent_change" do
    it "finds the percentage difference between two numbers" do
      expect(@stats_finder.percentage_change(2.4, 1.8)).to be == (33.33333333333333)
    end
  end

  describe "#improved_receiver_score" do
    it "returns an array of differences between original receiver satisifaction score and reversed score" do
      expect(@stats_finder.improved_receiver_score).to be == ([0,2,0,0,2])
    end
  end

  describe "#average_improvement_satisfaction_score" do
    it "returns the average improvement in satisifcation score on a hundred point scale" do
      expect(@stats_finder.average_improvement_satisfaction_score).to be == (16.0)
    end
  end
end
