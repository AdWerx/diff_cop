require 'diff_cop/version'
require 'git_diff_parser'
require 'json'

class DiffCop
  attr_accessor :patches, :raw_lint_results, :lint_results

  # generate patches, run the linter and filter to only relevant results
  def start
    @patches = generate_patches.group_by(&:file)
    @raw_lint_results = parsed_raw_lint_results(patches.keys)
    @lint_results = filter_raw_lint_results(raw_lint_results['files'], patches)

    self
  end

  # take the generated lint results and print the relevant offenses
  # to stdout (CLI)
  def print!
    fail 'must run #start before printing' unless @lint_results
    messages = @lint_results.flat_map do |(file_path, offenses)|
      offense_line_map = offenses.group_by { |o| o['location']['line'] }
      offense_line_map.map do |(line_no, line_offenses)|
        <<-MSG
#{file_path}:#{line_no}:

    #{line_offenses.first['content']}
    #{line_offenses.map { |o| o['message'] }.join("\n    ")}
        MSG
      end
    end

    if @lint_results.empty?
      puts "\nYou're good! Rubocop has no offenses to report.\n"
      exit 0
    end

    puts <<-MSG

DiffCop Offenses:
=====================

#{messages.join("\n\n")}

MSG

    exit 1
  end

  private

  # get git diff output for staged files A or M filtered
  # with .rb or .rake extensions
  def diff_output
    `
      git diff \
        --diff-filter=AM \
        --ignore-space-at-eol \
        --no-color \
        --cached \
        -p \
        -- '*.rb' '*.rake'
    `
  end

  def generate_patches
    GitDiffParser.parse(diff_output)
  end

  # json-parsed rubocop results
  def parsed_raw_lint_results(*files)
    JSON.parse(`rubocop -R #{files.join(' ')} --format json`)
  end

  # do the provided patches include the given line number?
  def patches_include_line_number?(file_patches, line_number)
    file_patches.flat_map(&:changed_line_numbers).include?(line_number)
  end

  # get the line content from the patch containing the provided line number
  def get_line_content(file_patches, line_number)
    find_patch_for_line_number(file_patches, line_number).
      changed_lines.
      detect { |line| line.number == line_number }.
      instance_variable_get(:@content)
  end

  # find the patch in the provided list which contains the line number provided
  def find_patch_for_line_number(file_patches, line_number)
    file_patches.detect do |patch|
      patch.changed_line_numbers.include?(line_number)
    end
  end

  # [{
  #   path: ...,
  #   offenses: []
  # }]
  #
  # []<GitDiffParser::Patch>
  def filter_raw_lint_results(raw_lint_results, all_patches)
    raw_lint_results.inject({}) do |memo, result|
      file_patches = all_patches.fetch(result['path'])

      relevant_offenses = result['offenses'].select do |offense|
        line_no = offense['location']['line']
        next false unless patches_include_line_number?(file_patches, line_no)
        offense['content'] = get_line_content(file_patches, line_no)
      end

      memo[result['path']] = relevant_offenses if relevant_offenses.any?
      memo
    end
  end

end
