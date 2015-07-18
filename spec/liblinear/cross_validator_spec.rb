$: << File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
require 'liblinear'

describe Liblinear::CrossValidator do
  before do
    @problem = Liblinear::Problem.new([1, 2], [[1],[2]])
    @parameter_1 = Liblinear::Parameter.new
    @parameter_2 = Liblinear::Parameter.new({ solver_type: Liblinear::L2R_L2LOSS_SVR })

    @cv_classification = Liblinear::CrossValidator.new(@problem, @parameter_1, 2)
    @cv_classification.execute
    @cv_regression = Liblinear::CrossValidator.new(@problem, @parameter_2, 2)
    @cv_regression.execute
  end

  describe '#accuracy' do
    it 'returns accuracy' do
      expect(@cv_classification.accuracy.class).to eq(Float)
    end
  end

  describe '#mean_squared_error' do
    it 'returns mean_squared_error' do
      expect(@cv_regression.mean_squared_error.class).to eq(Float)
    end
  end

  describe 'squared_correlation_coefficient' do
    it 'returns squared_correlation_coefficient' do
      expect(@cv_regression.squared_correlation_coefficient.class).to eq(Float)
    end
  end
end
