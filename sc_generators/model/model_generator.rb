require 'sproutcore/generator_helper'

class ModelGenerator < RubiGen::Base

  include SproutCore::GeneratorHelper

  default_options :author => nil

  attr_reader :name, :client_location

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty? || !file_structure_exists?
    @name = args.shift
    extract_options
    assign_names!(@name)
  end

  def manifest
    record do |m|
      fp = client_file_path('models','js')
      build_client_directories(m, fp)
      m.template 'model.js', fp

      fp = client_file_path('fixtures','js')
      build_client_directories(m, fp)
      m.template 'fixture.js', fp

      fp = client_file_path('tests/models', 'rhtml')
      build_client_directories(m, fp)
      m.template 'test.rhtml', fp
    end
  end

  protected
    def banner
      <<-EOS
Creates a SproutCore model objects

USAGE: #{$0} #{spec.name} client_name/model_name [ClassName]
EOS
    end

    def add_options!(opts)
      opts.on("-l", '--loc="Location"', String, "Location of build. If not passed, search clients and frameworks dirs", "Default: none") { |options[:loc]| }
    end

    def extract_options
      @client_location = options[:loc]
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end
