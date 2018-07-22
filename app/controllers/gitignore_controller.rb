require 'tmpdir'

class GitignoreController < ApplicationController
  def check
    render json: JSON.pretty_generate(execute_git_check_ignore(paths: params['paths'].split(/\s+/), gitignore: params['gitignore']))
  end

  private

  def execute_git_check_ignore(paths:, gitignore:)
    Rails.logger.info("git check ignore #{paths.join(' ')[0..63]} input #{gitignore[0..63]}".scrub)

    result = {}

    Dir.mktmpdir do |dir|
      `cd #{dir} && git init`

      # コメントと末尾の空白を削除する。これを行わないと行数を取得できない
      gitignore.gsub!(/#.*/, '')
      gitignore.gsub!(/\s+$/, '')
      Rails.logger.info("git check ignore #{gitignore[0..63]}".scrub)

      File.write("#{dir}/.gitignore", gitignore)
      output = `cd #{dir} && git check-ignore -v #{Shellwords.join(paths)}`
      Rails.logger.info("git check ignore #{output[0..63]}".scrub)

      output.each_line do |line|
        Rails.logger.info("git check ignore #{line}".scrub)
        m = /^([^:]*):(\d*):([^\s]+)\s+(.+)/.match(line)
        next unless m
        path = m[4]
        result[path] = {
          line: m[2].present? ? m[2].to_i : nil,
          pattern: m[3].presence
        }
      end
    end

    result
  end
end
