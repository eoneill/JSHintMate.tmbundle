module JSHintMate

  def self.output(file, config, parser)
    config = config_path(config)
    format = (parser != :detail) ? :text : :html;
    parser = parser(parser)
    out = %x(jshint "#{file}" --config "#{config}" --reporter "#{parser}")
    if not out.empty?
      puts format == :html ? File.read(File.join(File.dirname(__FILE__), 'output.html')).gsub(/\{body\}/, out) : out
    end
  end

  def self.warn_about_unused_variables?
    %w[true 1 on yes y].include?(ENV['TM_JSHINTMATE_WARN_ABOUT_UNUSED_VARIABLES'])
  end

private

  CONFIG    = '.jshintrc'
  REPORTERS = {
    :simple => 'simple.js',
    :detail => 'detailed.js'
  }

  def self.config_path(path = '')
    # check for the file in our current path
    config = resolve_config_path(path)
    # if we still didn't find it, check for the file in the $HOME directory
    config = resolve_config_path(ENV['HOME'], false) if config.nil?
    # as a last resort use the one in this working directory
    config = resolve_config_path(File.dirname(__FILE__), false) if config.nil?
    return config
  end

  def self.parser(parser = :detailed)
    return File.join(File.dirname(__FILE__), REPORTERS[parser] || REPORTERS[:detail])
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
end
