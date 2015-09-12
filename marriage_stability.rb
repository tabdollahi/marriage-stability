require 'namey'
$generator = Namey::Generator.new

module Person
  attr_accessor :name, :preferences
  attr_reader :fiance

  def initialize
    @preferences = nil
    @name = nil
    @fiance = nil
  end

  def single?
    @fiance == nil 
  end

  def engage(partner)
    @fiance = partner
  end

  def unengage
    @fiance = nil
  end

end

class Initiator 
  include Person

  def propose_to_next_preferred
    highest_ranked_unproposed = self.preferences[0]
    highest_ranked_unproposed.proposal_review(self)
    self.preferences.shift
  end
  
end

class Receiver
  include Person

  def proposal_review(initiator)
    if self.single?
      new_suitor_acceptance(initiator)
    else
      compare_suitors(initiator)
    end
  end

  def new_suitor_acceptance(initiator)
    self.engage(initiator)
    initiator.engage(self)  
  end

  def compare_suitors(initiator)
    if self.preferences.index(initiator) < self.preferences.index(self.fiance)
      self.fiance.unengage
      new_suitor_acceptance(initiator)
    end
  end

end

class StableMatching

  attr_reader :initiators, :receivers

  def initialize(participant_count, preferences=nil)
    @initiators = Array.new(participant_count) {Initiator.new}
    @receivers = Array.new(participant_count) {Receiver.new}
    set_names_male(@initiators)
    set_names_female(@receivers)
    set_preferences(preferences)
  end

  def dating_game
    while @initiators.any? { |initiator| initiator.single? }
      play_round
    end
  end

  def play_round
    @initiators.each do |current_suitor|
      if current_suitor.single?
        current_suitor.propose_to_next_preferred
      end
    end
  end

  def display_preferences
    display_helper(@initiators)
    display_helper(@receivers)
  end

  def display_final_engagements
    puts "*"*80
    puts "Final Engagements"
    @receivers.each do |receiver|
      puts "#{receiver.name}: #{receiver.fiance.name}"
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

  def set_names_male(group)
    group.each do |person|
      person.name = $generator.male
    end
  end

  def set_names_female(group)
    group.each do |person|
      person.name = $generator.female
    end
  end

  def set_preferences_helper(group_one, group_two)
    group_one.each do |person|
      person.preferences = group_two.shuffle
    end
  end

  def set_preferences(preferences)
    if preferences.nil?
      set_preferences_helper(@initiators, @receivers)
      set_preferences_helper(@receivers, @initiators)
    else 
      preferences[:initiators].each do |k,v|
        @initiators[k].preferences = v.map!{|num| @receivers[num]}
      end
      preferences[:receivers].each do |k,v|
        @receivers[k].preferences = v.map!{|num| @initiators[num]}
      end
    end
  end

end

test = StableMatching.new(4)


test.display_preferences
test.dating_game
test.display_final_engagements
