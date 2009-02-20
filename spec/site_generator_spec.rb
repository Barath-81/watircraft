require 'spec/spec_helper'
require 'spec/spec_generator_helper'
require 'rubygems'
require 'fileutils'
require 'taza'

describe "Site Generation" do
  include RubiGen::GeneratorTestHelper
  include Helpers::Generator
  include Helpers::Taza
  
  before :all do
    @spec_helper = File.join(TMP_ROOT,PROJECT_NAME,'spec','spec_helper.rb')
    @site_name = "WikipediaFoo"
    @site_file = File.join(PROJECT_FOLDER,'lib', "wikipedia_foo.rb")
    @site_folder = File.join(PROJECT_FOLDER,'lib')
    @page_folder = File.join(@site_folder, 'pages')
  end

  before :each do
    bare_setup
    run_generator('watircraft', [APP_ROOT], generator_sources)
  end

  after :each do
    bare_teardown
  end

  it "should generate configuration file for a site" do
    run_generator('site', [@site_name], generator_sources)
    File.exists?(File.join(PROJECT_FOLDER,'config','environments.yml')).should be_true
  end

  it "should generate a site path for pages" do
    run_generator('site', [@site_name], generator_sources)
    File.directory?(@site_folder).should be_true
    File.directory?(@page_folder).should be_true
  end
  
  it "should generate a site path even if the site name is given with spaces" do
    run_generator('site', ["Wikipedia Foo"], generator_sources)
    File.directory?(@site_folder).should be_true
    File.directory?(@page_folder).should be_true
  end
  
  it "should generate a site path even if the site name is given with underscores" do
    run_generator('site', ["wikipedia_foo"], generator_sources)
    File.directory?(@site_folder).should be_true
    File.directory?(@page_folder).should be_true
  end

  it "generated site that uses the block given in new" do
    @site_class = generate_site(@site_name)
    stub_settings
    stub_browser
    foo = nil
    @site_class.new {|site| foo = site}
    foo.should_not be_nil
    foo.should be_a_kind_of(Taza::Site)
  end

end
