require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'aasm')

class Conversation
  include AASM

  aasm_initial_state :needs_attention

  aasm_state :needs_attention
  aasm_state :read
  aasm_state :closed
  aasm_state :awaiting_response
  aasm_state :junk

  aasm_event :new_message do
  end

  aasm_event :view do
    transitions :to => :read, :from => [:needs_attention]
  end

  aasm_event :reply do
  end

  aasm_event :close do
    transitions :to => :closed, :from => [:read, :awaiting_response]
  end

  aasm_event :junk do
    transitions :to => :junk, :from => [:read]
  end

  aasm_event :unjunk do
  end
  
  aasm_event :args_test do
    transitions :to => :junk, :from => [:needs_attention], :on_transition => :transition_method
  end

  def initialize(persister)
    @persister = persister
  end

  def transition_method(*args)
    p "transition_method: #{args}"
  end

  private
  def aasm_read_state
    @persister.state
  end

  def aasm_write_state(state)
    @persister.state = state
  end

end
