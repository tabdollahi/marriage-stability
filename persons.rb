class Person
  attr_accessor :name, :preferences, :fiance
  attr_reader :unproposed_list

  def initialize(name = nil, preferences = nil)
    @preferences = preferences
    @name = name
    @fiance = nil
    @unproposed_list = nil
  end

  def single?
    @fiance == nil 
  end

  def engage(partner)
    @fiance = partner
    partner.fiance = self
  end

  def unengage(current_fiance)
    @fiance = nil
    current_fiance.fiance = nil
  end

  def propose_to_next_preferred
    @unproposed_list = @unproposed_list || @preferences.dup
    highest_ranked_unproposed = @unproposed_list[0]
    highest_ranked_unproposed.proposal_review(self)
    @unproposed_list.shift
  end

  def proposal_review(initiator)
    if self.single?
      engage(initiator)
    else
      compare_suitors(initiator)
    end
  end

  def compare_suitors(initiator)
    if @preferences.index(initiator) < @preferences.index(@fiance)
      unengage(@fiance)
      engage(initiator)
    end
  end

end