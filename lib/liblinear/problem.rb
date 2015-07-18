module Liblinear
  class Problem
    include Liblinear
    include Liblinearswig
    attr_reader :labels, :examples

    # @param labels [Array <Double>]
    # @param examples [Array <Double, Hash>]
    # @param bias [Double]
    # @raose [ArgumentError]
    def initialize(labels, examples, bias = -1)
      if labels.size != examples.size
        raise ArgumentError, 'the size of labels is different from that of examples'
      end

      @problem = Liblinearswig::Problem.new
      @labels = labels
      @examples = examples

      @problem.y = new_double_array(labels)
      @problem.bias = bias
      @problem.l = examples.size

      example_matrix = feature_node_matrix(examples.size)
      examples.size.times do |index|
        feature_node_matrix_set(
          example_matrix,
          index,
          convert_to_feature_node_array(examples[index], max_index(examples), bias)
        )
      end

      @problem.x = example_matrix
      @problem.n = max_index(examples)
      @problem.n += 1 if bias >= 0
    end

    # @return [Liblinearswig::Problem]
    def to_c
      @problem
    end
  end
end
