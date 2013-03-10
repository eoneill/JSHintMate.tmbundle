require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'

module JSHintMate

  def self.output(reporter)
    format = (reporter != :detail) ? :text : :html;
    out = %x(#{command(reporter)})
    if not out.empty?
      puts format == :html ? File.read(File.join(File.dirname(__FILE__), 'output.html')).gsub(/\{body\}/, out) : out
    end
  end

private

  CONFIG    = '.jshintrc'
  REPORTERS = {
    :simple => 'simple.js',
    :detail => 'detailed.js'
  }

  def self.config_path(path = nil)
    # first check for the project config being set
    config = ENV['TM_JSHINTMATE_CONFIG']
    # check for the file in our current path
    config ||= resolve_config_path(path)
    # if we still didn't find it, check for the file in the $HOME directory
    config ||= resolve_config_path(ENV['HOME'], false)
    # as a last resort use the one in this working directory
    config ||= resolve_config_path(File.dirname(__FILE__), false)
    config = expand_file_path config, 'configuration'
    return config
  end

  def self.parser(reporter = :detail)
    reporter = ENV['TM_JSHINTMATE_REPORTER'] || File.join(File.dirname(__FILE__), REPORTERS[reporter] || REPORTERS[:detail])
    #reporter = File.expand_path(reporter)
    reporter = expand_file_path reporter, 'reporter'
    return reporter
  end

  # resolve the file path by climbing up the directory tree
  def self.resolve_config_path(path = '', climb = true)
    # return early if we're at the root
    return nil if path.nil? or path.empty? or path == '/'

    # check if the file exists in the current path...
    file = File.join(path, CONFIG)
    return file if File.exist?(file)

    # othwerise, recurse
    return resolve_config_path(File.expand_path('..', path), true) if climb

    # or return nil
    return nil
  end

  def self.command(reporter)
    # default values for exports, if not set in .tm_properties
    exports = {
      'TM_JSHINTMATE_WARN'          => false,
      'TM_JSHINTMATE_WARN_UNUSED'   => '$TM_JSHINTMATE_WARN',
      'TM_JSHINTMATE_WARN_GLOBALS'  => '$TM_JSHINTMATE_WARN',
      'TM_JSHINTMATE_RAW'           => false,
      'TM_JSHINTMATE_PEVIEW_MAX'    => 5
    }
    config = config_path(ENV['TM_DIRECTORY'])
    reporter = parser(reporter)
    cmd = ENV['TM_JSHINTMATE_COMMAND'] || 'jshint "{FILE}" --config "{CONFIG}" --reporter "{REPORTER}"'
    cmd = cmd.gsub(/\{FILE\}/i, ENV['TM_FILEPATH']).gsub(/\{CONFIG\}/i, config).gsub(/\{REPORTER\}/i, reporter)
    # export some settings so Node has access to them
    exports.each do |export|
      cmd.insert 0, "export #{export[0]}=#{(ENV[export[0]] || export[1])};"
    end
    return cmd
  end

  def self.expand_file_path(file, type = nil)
    file = File.expand_path(file)
    type = ' ' + type if not type.nil?
    throw_exception "The#{type} file `#{file}` does not exist", !File.exists?(file)
    return file
  end

  def self.throw_exception(message, condition = true)
    # indent the message
    message = (message || '').gsub(/\n/, '  \n')
    TextMate.exit_show_tool_tip "JSHintMate Exception:\n  #{message}" if condition
  end

end
