class AASM::SupportingClasses::StateTransition
  attr_reader :from, :to, :opts
  alias_method :options, :opts

  def initialize(opts)
    @from, @to, @guard, @on_transition = opts[:from], opts[:to], opts[:guard], opts[:on_transition]
    @opts = opts
  end

  def perform(obj)
    case @guard
      when Symbol, String
        obj.send(@guard)
      when Proc
        @guard.call(obj)
      else
        true
    end
  end

  def execute(obj, *args)
    transition_args = args[1..-1]
    @on_transition.is_a?(Array) ?
            @on_transition.each {|ot| _execute(obj, ot, *transition_args)} :
            _execute(obj, @on_transition, *transition_args)
  end

  def ==(obj)
    @from == obj.from && @to == obj.to
  end

  def from?(value)
    @from == value
  end

  private

  def _execute(obj, on_transition, *args)
    case on_transition
      when Symbol, String
        obj.send(on_transition, *args)
      when Proc
        on_transition.call(obj, *args)
    end
  end

end
