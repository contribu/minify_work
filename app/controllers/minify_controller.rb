require 'tempfile'

class MinifyController < ApplicationController
  def minify
    Timeout.timeout(3 * 60) do
      compressor = {
        closure_compiler: 'gcc'
      }[params['compressor'].to_sym] || params['compressor']
      render js: execute_node_minify(input: params['input'], compressor: compressor)
    end
  end

  private

  def execute_node_minify(input:, compressor:)
    Rails.logger.info("minify compressor #{compressor} input #{input[0..63]}".scrub)

    input_file = Tempfile.new
    output_file = Tempfile.new
    File.write(input_file.path, input)
    `node script/minify.js --input #{input_file.path} --output #{output_file.path} --compressor #{compressor}`
    File.read(output_file.path)
  end
end
