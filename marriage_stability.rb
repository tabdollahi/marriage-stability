require 'namey'
$generator = Namey::Generator.new

class Person
  attr_accessor :preferences, :name, :single

  def initialize
    @preferences = nil
    @name = nil
    @single = true
  end

  def single?
    @single
  end

end

class StableMatching

  attr_reader :initiators, :receivers

  def initialize(participant_count, preferences=nil)
    @initiators = Array.new(participant_count) {Person.new}
    @receivers = Array.new(participant_count) {Person.new}
    set_names_male(@initiators)
    set_names_female(@receivers)
    set_preferences(preferences)
    @engagements = {}
  end

  def dating_game
    while @initiators.any? { |initiator| initiator.single? }
      play_round
    end
  end

  def play_round
    @initiators.each do |current_suitor|
      if current_suitor.single?
        highest_ranked_unproposed = current_suitor.preferences[0]
        if highest_ranked_unproposed.single?
          propose_and_engage(current_suitor, highest_ranked_unproposed)
        else
          receiver_fiance = @engagements[highest_ranked_unproposed]
          if highest_ranked_unproposed.preferences.index(current_suitor) < highest_ranked_unproposed.preferences.index(receiver_fiance)
            dump_fiance(receiver_fiance, highest_ranked_unproposed)
            propose_and_engage(current_suitor, highest_ranked_unproposed)
          end
        end 
        current_suitor.preferences.shift
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
    @engagements.each do |k,v|
      puts "#{k.name}:#{v.name}"
    end
    puts "*"*80
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

   def propose_and_engage(initiator, receiver)
    initiator.single = false
    receiver.single = false 
    @engagements[receiver] = initiator
  end

  def dump_fiance(fiance, receiver)
    fiance.single = true
    @engagements.delete(receiver)
  end
end

test = StableMatching.new(4)


test.display_preferences
test.dating_game
test.display_final_engagements
