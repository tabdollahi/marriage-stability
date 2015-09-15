require "./marriage_stability"

describe "MarriageStabilityStats" do

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
    @nancy = Person.new("Nancy", [@rober, @john, @richard, @anthony, @william])


    @william.preferences = [@deborah, @elizabeth, @dorothy, @nancy, @jennifer]
    @robert.preferences = [@dorothy, @deborah, @elizabeth, @nancy, @jennifer]
    @richard.preferences = [@jennifer, @dorothy, @elizabeth, @nancy, @deborah]
    @anthony.preferences = [@deborah, @jennifer, @elizabeth, @dorothy, @nancy]
    @john. preferences = [@deborah, @elizabeth, @nancy, @jennifer, @dorothy]

    initiators = [@william, @robert, @richard, @anthony, @john]
    receivers = [@elizabeth, @jennifer, @deborah, @dorothy, @nancy]

    @simulation = StableMatching.new(SpecificPersonsGenerator.new(initiators, receivers))
    @stats_finder = MarriageStabilityStats.new

  end

  describe "#average_group_partner_rank" do
    # before :each do
    #   @simulation.dating_game
    #   @simulation.display_marital_statuses
    # end
    it "finds the average rank of the receivers' respective final partners" do
      expect(@stats_finder.average_group_partner_rank(@simulation, :receivers)).to be ==(2.4)
    end
    it "finds the average rank of the initiators' respective final partners" do
      expect(@stats_finder.average_group_partner_rank(@simulation, :initiators)).to be ==(1.8)
    end
  end

  describe "#percentage difference group scores" do
    it "finds the percentage difference between initiators' and receivers' average group partner rankings" do
      expect(@stats_finder.percentage_difference_group_scores(@simulation)).to be ==(33.33333333333333)
    end
  end
end
