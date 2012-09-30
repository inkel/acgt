require "mote"

module ACGT
  VERSION = "0.0.1".freeze

  @options = { output: nil, edit: false }

  extend self

  def help
    readme = File.expand_path("../README", File.dirname(__FILE__))
    exec "${PAGER:-less} #{ readme }"
  end

  def output path
    @options[:output] = File.absolute_path(path)
  end

  def parse params
    {}.tap do |vars|
      params.each do |param|
        name, value = param.split(":", 2)
        name = name.to_sym
        if vars[name]
          vars[name] = [vars[name]] unless vars[name].is_a?(Array)
          vars[name] << value if value && !value.empty?
        else
          vars[name] = value
        end
      end
    end
  end

  def edit_template
    @options[:edit] = true
  end

  def get_template_file template
    get_template_file_from_cwd(template) || get_template_file_from_home(template)
  end

  def get_template_file_from_cwd template
    get_template_file_from File.join(Dir.pwd, ".acgt"), template
  end

  def get_template_file_from_home template
    get_template_file_from(File.join(ENV["HOME"], ".acgt"), template)
  end

  def get_template_file_from dir, template
    file = File.join(File.absolute_path(dir), "#{ template }.mote")
    file if File.exists?(file)
  end

  def render template, params
    vars = parse params
    Mote.parse(File.read(template), self, vars.keys).call(vars)
  end

  def run template, params
    file = get_template_file template

    if @options[:edit]
      if file.nil?
        file = File.join(ENV["HOME"], ".acgt", "#{template}.mote")
        STDERR.puts "Creating template #{ file }"
      end
      exec "$EDITOR #{ file }"
    end

    if file.nil?
      STDERR.puts "Template #{template} doesn't exists in #{Dir.pwd}/.acgt or ~/.acgt."
      exit 1
    end

    dna = render file, params

    if @options[:output]
      output = File.absolute_path(@options[:output])
      STDOUT.puts "Generating #{output}"
      File.open(output, "w") do |fp|
        fp.write dna
      end
    else
      STDOUT.puts dna
    end
  end
end
