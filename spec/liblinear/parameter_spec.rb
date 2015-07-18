$: << File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
require 'liblinear'

describe Liblinear::Parameter do
  before do
    @default_parameter = Liblinear::Parameter.new
    @parameter         = Liblinear::Parameter.new({
      solver_type:    Liblinear::L2R_LR,
      cost:           2,
      sensitive_loss: 0.5,
      epsilon:        0.2,
      weight_labels:  [1, 2, 3],
      weights:        [1.0, 2.0, 3.0],
    })
  end

  describe '#initialize' do
    it 'raise Liblinear::Parameter::InvalidError when the size of weight_labels is different from that of weights' do
      expect {
        @invalid_parameter = Liblinear::Parameter.new({
          weight_labels: [1, 2, 3],
          weights:       [1.0],
        })
      }.to raise_error(Liblinear::Parameter::InvalidError, 'the size of weight_labels is different from that of weights')
    end
  end

  describe '#solver_type' do
    it 'returns default value' do
      expect(@default_parameter.solver_type).to eq(Liblinear::L2R_L2LOSS_SVC_DUAL)
    end

    it 'returns solver type' do
      expect(@parameter.solver_type).to eq(Liblinear::L2R_LR)
    end
  end

  describe '#cost' do
    it 'returns default value' do
      expect(@default_parameter.cost).to eq(1.0)
    end

    it 'returns C parameter' do
      expect(@parameter.cost).to eq(2)
    end
  end

  describe '#epsilon' do
    it 'returns default value' do
      expect(@default_parameter.epsilon).to eq(0.1)
    end

    it 'returns epsilon' do
      expect(@parameter.epsilon).to eq(0.2)
    end
  end

  describe '#sensitive_loss' do
    it 'returns default value' do
      expect(@default_parameter.sensitive_loss).to eq(0.1)
    end

    it 'returns sensitive_loss' do
      expect(@parameter.sensitive_loss).to eq(0.5)
    end
  end

  describe '#weight_label' do
    it 'returns default value' do
      expect(@default_parameter.weight_labels.class).to eq(SWIG::TYPE_p_int)
    end

    it 'returns weight_label' do
      expect(@parameter.weight_labels.class).to eq(SWIG::TYPE_p_int)
    end
  end

  describe '#weights' do
    it 'returns default value' do
      expect(@default_parameter.weights.class).to eq(SWIG::TYPE_p_double)
    end

    it 'returns weights' do
      expect(@parameter.weights.class).to eq(SWIG::TYPE_p_double)
    end
  end

  describe '#to_c' do
    it 'returns instance of Liblinearswig::Parameter' do
      expect(@parameter.to_c.class).to eq(Liblinearswig::Parameter)
    end
  end
end
