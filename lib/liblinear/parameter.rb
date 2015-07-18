module Liblinear
  class Parameter
    class InvalidError < StandardError
    end

    include Liblinear
    include Liblinearswig

    # @param parameter [Hash]
    # @raise [Liblinear::Parameter::InvalidError]
    def initialize(parameter = {})
      parameter[:weight_labels] = [] if parameter[:weight_labels].nil?
      parameter[:weights]       = [] if parameter[:weights].nil?

      if parameter[:weight_labels].size != parameter[:weights].size
        raise Liblinear::Parameter::InvalidError, 'the size of weight_labels is different from that of weights'
      end

      @parameter = Liblinearswig::Parameter.new

      @parameter.solver_type = parameter[:solver_type] || Liblinear::L2R_L2LOSS_SVC_DUAL
      @parameter.C           = parameter[:cost] || 1.0
      @parameter.p           = parameter[:sensitive_loss] || 0.1
      @parameter.eps         = parameter[:epsilon] || default_epsilon
      @parameter.nr_weight    = parameter[:weight_labels].size
      @parameter.weight_label = new_int_array(parameter[:weight_labels])
      @parameter.weight       = new_double_array(parameter[:weights])
    end

    # @return [Integer]
    def solver_type
      @parameter.solver_type
    end

    # @return [Double]
    def cost
      @parameter.C
    end

    # @return [Double]
    def sensitive_loss
      @parameter.p
    end

    # @return [Double]
    def epsilon
      @parameter.eps
    end

    # @return [Array <Integer>]
    def weight_labels
      @parameter.weight_label
    end

    # @return [Array <Double>]
    def weights
      @parameter.weight
    end

    # @return [Liblinearswig::Parameter]
    def to_c
      @parameter
    end

    private

    # @return [Double]
    def default_epsilon
      case @parameter.solver_type
      when Liblinear::L2R_LR then
        0.01
      when Liblinear::L2R_L2LOSS_SVC_DUAL then
        0.1
      when Liblinear::L2R_L2LOSS_SVC then
        0.01
      when Liblinear::L2R_L1LOSS_SVC_DUAL then
        0.1
      when Liblinear::MCSVM_CS then
        0.1
      when Liblinear::L1R_L2LOSS_SVC then
        0.01
      when Liblinear::L1R_LR then
        0.01
      when Liblinear::L2R_LR_DUAL then
        0.1
      when Liblinear::L2R_L2LOSS_SVR then
        0.001
      when Liblinear::L2R_L2LOSS_SVR_DUAL then
        0.1
      when Liblinear::L2R_L1LOSS_SVR_DUAL then
        0.1
      end
    end
  end
end
