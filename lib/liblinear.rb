$: << File.expand_path(File.join(__FILE__, '..', '..', 'ext'))

require 'liblinearswig'
require 'liblinear/cross_validator'
require 'liblinear/model'
require 'liblinear/parameter'
require 'liblinear/problem'
require 'liblinear/version'

module Liblinear
  L2R_LR              = Liblinearswig::L2R_LR
  L2R_L2LOSS_SVC_DUAL = Liblinearswig::L2R_L2LOSS_SVC_DUAL
  L2R_L2LOSS_SVC      = Liblinearswig::L2R_L2LOSS_SVC
  L2R_L1LOSS_SVC_DUAL = Liblinearswig::L2R_L1LOSS_SVC_DUAL
  MCSVM_CS            = Liblinearswig::MCSVM_CS
  L1R_L2LOSS_SVC      = Liblinearswig::L1R_L2LOSS_SVC
  L1R_LR              = Liblinearswig::L1R_LR
  L2R_LR_DUAL         = Liblinearswig::L2R_LR_DUAL
  L2R_L2LOSS_SVR      = Liblinearswig::L2R_L2LOSS_SVR
  L2R_L2LOSS_SVR_DUAL = Liblinearswig::L2R_L2LOSS_SVR_DUAL
  L2R_L1LOSS_SVR_DUAL = Liblinearswig::L2R_L1LOSS_SVR_DUAL

  # @param ruby_array [Array <Integer>]
  # @return [SWIG::TYPE_p_int]
  def new_int_array(ruby_array)
    c_int_array = Liblinearswig.new_int(ruby_array.size)
    ruby_array.size.times do |index|
      Liblinearswig.int_setitem(c_int_array, index, ruby_array[index])
    end
    c_int_array
  end

  # @param c_array [SWIG::TYPE_p_int]
  def free_int_array(c_array)
    delete_int(c_array) unless c_array.nil?
  end

  # @param ruby_array [Array <Double>]
  # @return [SWIG::TYPE_p_double]
  def new_double_array(ruby_array)
    c_double_array = Liblinearswig.new_double(ruby_array.size)
    ruby_array.size.times do |index|
      Liblinearswig.double_setitem(c_double_array, index, ruby_array[index])
    end
    c_double_array
  end

  # @param c_array [SWIG::TYPE_p_double]
  def free_double_array(c_array)
    delete_double(c_array) unless c_array.nil?
  end

  # @param c_array [SWIG::TYPE_p_int]
  # @param size [Integer]
  # @return [Array<Integer>]
  def int_array_c_to_ruby(c_array, size)
    size.times.map {|index| int_getitem(c_array, index)}
  end

  # @param c_array [SWIG::TYPE_p_double]
  # @param size [Integer]
  # @return [Array <Double>]
  def double_array_c_to_ruby(c_array, size)
    size.times.map {|index| double_getitem(c_array, index)}
  end

  # @param examples [Array <Hash, Array>]
  # @return [Integer]
  def max_index(examples)
    max_index = 0
    examples.each do |example|
      if example.is_a?(Hash)
        max_index = [max_index, example.keys.max].max if example.size > 0
      else
        max_index = [max_index, example.size].max
      end
    end
    max_index
  end

  # @param array [Array]
  # @return [Hash]
  def array_to_hash(array)
    raise ArgumentError unless array.is_a?(Array)
    hash = {}
    key = 1
    array.each do |value|
      hash[key] = value
      key += 1
    end
    hash
  end

  # @param example [Hash, Array]
  # @param max_value_index [Integer]
  # @param bias [Double]
  # @return [Liblinearswig::Feature_node]
  def convert_to_feature_node_array(example, max_value_index, bias = -1)
    example = array_to_hash(example) if example.is_a?(Array)

    example_indexes = []
    example.each_key do |key|
      example_indexes << key
    end
    example_indexes.sort!

    if bias >= 0
      feature_nodes = Liblinearswig.feature_node_array(example_indexes.size + 2)
      Liblinearswig.feature_node_array_set(feature_nodes, example_indexes.size, max_value_index + 1, bias)
      Liblinearswig.feature_node_array_set(feature_nodes, example_indexes.size + 1, -1, 0)
    else
      feature_nodes = Liblinearswig.feature_node_array(example_indexes.size + 1)
      Liblinearswig.feature_node_array_set(feature_nodes, example_indexes.size, -1, 0)
    end

    f_index = 0
    example_indexes.each do |e_index|
      Liblinearswig.feature_node_array_set(feature_nodes, f_index, e_index, example[e_index])
      f_index += 1
    end
    feature_nodes
  end
end
