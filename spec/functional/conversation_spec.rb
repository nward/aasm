describe Conversation, 'description' do
  it '.aasm_states should contain all of the states' do
    Conversation.aasm_states.should == [:needs_attention, :read, :closed, :awaiting_response, :junk]
  end
  
  it 'should pass arguments received by event method to :on_transition method' do
    c = Conversation.new(Struct.new(:state).new)
    args = [nil, 1, 'a', Object.new]
    c.should_receive(:transition_method).with(*args)
    c.args_test(*args)
  end
end
