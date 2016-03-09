require "diff_cop/version"
require 'git_diff_parser'
require 'json'
require 'open3'

module DiffCop

  def self.start

    diff_output = %x(git diff --diff-filter=AM --ignore-space-at-eol --no-color --cached -p -- '*.rb' '*.rake')

    patches = GitDiffParser.parse(diff_output)

    binding.pry

  end
end
