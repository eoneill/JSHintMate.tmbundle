require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'

module JSHintMate

  #
  # outputs the result of running JSHint against the current file
  #
  # *Parameters*:
  # - <tt>reporter</tt> {Symbol} the reporter style to use [:simple|:detail]
  #
  def self.output(reporter = :detail)
    # break out early and do nothing is JSHintMate is disabled
    return if not (ENV['TM_JSHINTMATE'] || 'true') =~ TRUE_RX
    # choose between text or html output
    format = (reporter != :detail) ? :text : :html;
    # invoke our JSHint command and capture the output
    out = %x(#{command(reporter)})
    # if there was any captured...
    if not out.empty?
      # output it in the specified format
      puts format == :html ? File.read(tmpl).gsub(/\{body\}/, out) : out
    end
  end

private

  # some file constants
  CONFIG    = '.jshintrc'
  TEMPLATE  = 'output.html'
  REPORTERS = {
    :simple => 'simple.js',
    :detail => 'detailed.js'
  }
  # some regex
  TRUE_RX = /^(?:true|yes|1)$/i

  #
  # gets the path to the most appropriate JSHint configuration file
  #
  # *Parameters*:
  # - <tt>path</tt> {String} the path to start looking in
  #
  def self.get_config(path = nil)
    # first check for the project config being set
    config = ENV['TM_JSHINTMATE_CONFIG']
    # check for the file in our current path
    config ||= resolve_config_path(path)
    # if we still didn't find it, check for the file in the $HOME directory
    config ||= resolve_config_path(ENV['HOME'], false)
    # as a last resort use the one in this working directory
    config ||= resolve_config_path(File.dirname(__FILE__), false)
    return expand_file_path config, 'configuration'
  end

  #
  # resolves the file path to the config by climbing up the directory tree
  #
  # *Parameters*:
  # - <tt>path</tt> {String} the path to start looking in
  # - <tt>climb</tt> {Boolean} whether or not to continue climbing
  # *Returns*:
  # - {String|Nil} the resolved path to the config or `nil`
  #
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

  #
  # gets the path to the most appropriate reporter file
  #
  # *Parameters*:
  # - <tt>reporter</tt> {Symbol} the type of reporter to use [:simple|:detail]
  #
  def self.get_reporter(reporter = :detail)
    file = ENV['TM_JSHINTMATE_REPORTER'] || File.join(File.dirname(__FILE__), REPORTERS[reporter] || REPORTERS[:detail])
    return expand_file_path file, 'reporter'
  end

  #
  # gets the path to the most appropriate template file (for detail view)
  #
  # *Returns*:
  # - {String} the path to the template file
  #
  def self.tmpl
    file = ENV['TM_JSHINTMATE_TEMPLATE'] || File.join(File.dirname(__FILE__), TEMPLATE)
    return expand_file_path file, 'template'
  end

  #
  # determine the command the run
  #
  # *Parameters*:
  # - <tt>reporter</tt> {Symbol} the type of reporter to use [:simple|:detail]
  # *Returns*:
  # - {String} the command to be invoked
  #
  def self.command(reporter = :detail)
    # default values for exports, if not set in .tm_properties
    #  (note: this uses an array as Ruby < 1.9 doesn't support Ordered Hashes)
    exports = [
      { :key => 'TM_JSHINTMATE_WARN',         :value => false },
      { :key => 'TM_JSHINTMATE_WARN_UNUSED',  :value => '$TM_JSHINTMATE_WARN' }, # inherit the setting for TM_JSHINTMATE_WARN
      { :key => 'TM_JSHINTMATE_WARN_GLOBALS', :value => '$TM_JSHINTMATE_WARN' }, # inherit the setting for TM_JSHINTMATE_WARN
      { :key => 'TM_JSHINTMATE_RAW',          :value => false },
      { :key => 'TM_JSHINTMATE_PEVIEW_MAX',   :value => 5 }
    ]
    # get the config and reporter
    config = get_config(ENV['TM_DIRECTORY'])
    reporter = get_reporter(reporter)
    # compute the base command
    cmd = ENV['TM_JSHINTMATE_COMMAND'] || 'jshint "{FILE}" --config "{CONFIG}" --reporter "{REPORTER}"'
    cmd = cmd.gsub(/\{FILE\}/i, ENV['TM_FILEPATH']).gsub(/\{CONFIG\}/i, config).gsub(/\{REPORTER\}/i, reporter)
    # export some settings so Node has access to them
    cmds = []
    exports.each do |export|
      cmds.push "export #{export[:key]}=#{(ENV[export[:key]] || export[:value])}"
    end
    cmds.push cmd
    return cmds.join ';'
  end

  #
  # expand the file path and throw an exception if it doesn't exist
  #
  # *Parameters*:
  # - <tt>file</tt> {String} the path to the file to resolve
  # - <tt>type</tt> {String} the file type (used for reporting the exception)
  # *Returns*:
  # - {String} the expanded file path
  #
  def self.expand_file_path(file, type = nil)
    file = File.expand_path(file)
    type = ' ' + type if not type.nil?
    throw_exception "The#{type} file `#{file}` does not exist", !File.exists?(file)
    return file
  end

  #
  # throw a message in the TextMate tooltip and about if the condition is met
  #
  # *Parameters*:
  # - <tt>message</tt> {String} the exception to throw
  # - <tt>condition</tt> {Boolean} the condition to test against
  #
  def self.throw_exception(message, condition = true)
    # indent the message
    message = (message || '').gsub(/\n/, '  \n')
    TextMate.exit_show_tool_tip "JSHintMate Exception:\n  #{message}" if condition
  end

end
