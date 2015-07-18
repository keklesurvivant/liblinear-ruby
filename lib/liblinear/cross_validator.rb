module Liblinear
  class CrossValidator
    include Liblinear
    include Liblinearswig

    # @param problem [LibLinear::Problem]
    # @param parameter [Liblinear::Parameter]
    # @param fold [Integer]
    def initialize(prob, param, fold)
      @problem = prob
      @parameter = param
      @fold = fold
    end

    # @return [Array <Integer, Double>]
    def execute
      target = new_double_array(@problem.labels.size.times.map { 0.0 })
      cross_validation(@problem.to_c, @parameter.to_c, @fold, target)
      @predictions = double_array_c_to_ruby(target, @problem.labels.size)
    end

    # @return [Double]
    def accuracy
      total_correct = 0
      @problem.labels.size.times do |i|
        total_correct += 1 if @predictions[i] == @problem.labels[i].to_f
      end
      total_correct.to_f / @problem.labels.size.to_f
    end

    # @return [Double]
    def mean_squared_error
      total_error = 0.0
      @problem.labels.size.times do |i|
        total_error += (@problem.labels[i].to_f - @predictions[i].to_f) ** 2
      end
      total_error / @problem.labels.size.to_f
    end

    # @return [Double]
    def squared_correlation_coefficient
      sum_x = 0.0
      sum_y = 0.0
      sum_xx = 0.0
      sum_yy = 0.0
      sum_xy = 0.0
      @problem.labels.size.times do |i|
        sum_x += @predictions[i].to_f
        sum_y += @problem.labels[i].to_f
        sum_xx += @predictions[i].to_f ** 2
        sum_yy += @problem.labels[i].to_f ** 2
        sum_xy += @predictions[i].to_f * @problem.labels[i].to_f
      end
      ((@problem.labels.size * sum_xy - sum_x * sum_y) ** 2) /
        ((@problem.labels.size * sum_xx - sum_x ** 2) * (@problem.labels.size * sum_yy - sum_y ** 2))
    end
  end
end
