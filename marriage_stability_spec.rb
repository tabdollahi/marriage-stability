require "./marriage_stability"

describe "#dating_game" do
  before :each do
    preference_hash = {
        initiators: {
          0=> [0,1,2],
          1=> [1,0,2],
          2=> [2,1,0]
          },
        receivers: {
          0=> [0,1,2],
          1=> [0,1,2],
          2=> [1,0,2]
          }
      }
      @simulation = StableMatching.new(3, preference_hash)
  end

  it "continue simulation until all initiators are not single" do
    expect{@simulation.dating_game}.to change{@simulation.initiators.any? { |initiator| initiator.single? }}.from(true).to(false)
  end

end

describe "#proposal_review" do 
  before :each do
    preference_hash = {
        initiators: {
          0=> [0,1,2],
          1=> [0,1,2],
          2=> [1,2,0]
          },
        receivers: {
          0=> [0,1,2],
          1=> [0,1,2],
          2=> [1,0,2]
          }
      }
   @simulation = StableMatching.new(3, preference_hash)
  end

  context "when receiver has more than one offer" do
    it "receiver accepts preferred offer even if it's not first" do
        special_preference_hash = {
        initiators: {
          0=> [0,1,2],
          1=> [0,1,2],
          2=> [1,2,0]
          },
        receivers: {
          0=> [1,0,2],
          1=> [0,1,2],
          2=> [1,0,2]
          }
      }
      @simulation = StableMatching.new(3, special_preference_hash)
      expect{@simulation.play_round}.to change{@simulation.receivers[0].fiance}.from(nil).to(@simulation.initiators[1])
    end
  end

  context "when receiver of proposal is single" do
    it "receiver accepts proposal and becomes engaged to suitor" do
      expect{@simulation.play_round}.to change{@simulation.receivers[0].single?}.from(true).to(false)
    end
    it "initiator becomes engaged" do
      expect{@simulation.play_round}.to change{@simulation.initiators[0].single?}.from(true).to(false)
    end
  end

  context "when receiver of proposal is not single and prefers new suitor" do
    it "receiver becomes engaged to new suitor" do
      @simulation.play_round
      expect{@simulation.play_round}.to change{@simulation.receivers[1].fiance}.from(@simulation.initiators[2]).to(@simulation.initiators[1])
    end

    it "old fiance becomes unengaged" do
      @simulation.play_round
      expect{@simulation.play_round}.to change{@simulation.initiators[2].fiance}.from(@simulation.receivers[1]).to(nil)
    end
  end
end