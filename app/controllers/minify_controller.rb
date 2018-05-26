require 'tempfile'

class MinifyController < ApplicationController
  def closure_compiler
    render js: execute_node_minify(input: params[:input], compressor: 'gcc')
  end

  def uglifyjs
    render js: execute_node_minify(input: params[:input], compressor: 'uglifyjs')
  end

  private

  def execute_node_minify(input:, compressor:)
    temp_file = Tempfile.new
    File.write(input, temp_file.path)
    `node script/minify.js --input #{temp_file.path} --compressor #{compressor}`
  end
end
