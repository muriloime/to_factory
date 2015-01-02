describe ToFactory::FileWriter do
  describe "#all!" do
    let!(:user   ) { double("user",    :is_a? => true, :class => double(:name => "User")) }
    let!(:project) { double("project", :is_a? => true, :class => double(:name => "Project")) }
    let(:file_system  ) { double("file file_system" ) }
    let(:finder) { double("model finder") }
    let(:factories) { {:user => "factory a", :project => "factory b"} }

    context "with a finder and a file system" do
      let(:generator) { ToFactory::FileWriter.new(finder, file_system) }

      before do
        x(finder,      :all             ).r [user, project]
        x(file_system, :write, factories)
        x(generator,   :ToFactory       ).r("factory a", "factory b")
      end

      it "requests instances from the model finder and writes to the file file_system" do
        generator.all!
      end
    end


    context "with path arguments" do
      let(:models_path) { "a" }
      let(:factories_path) { "b" }
      let(:generator) do
        ToFactory::FileWriter.new(models_path, factories_path)
      end

      before do
        x(finder, :all).r [user, project]
        x(file_system, :write, {:user => "factory a", :project => "factory b"})
      end

      it "instantiates a finder and file_system with the passed path arguments" do
        x(ToFactory::ModelFinder, :new, models_path   ).r finder
        x(ToFactory::FileSystem,  :new, factories_path).r file_system
        x(generator,              :ToFactory          ).r("factory a", "factory b")
        generator.all!
      end
    end


  end
end

describe ToFactory::ModelFinder do
  let(:finder) { ToFactory::ModelFinder.new(path) }
  let(:path) { "spec/support" }

  describe "#all" do
    context "no match"do
      let(:path) { "tmp/doesnt_exist" }
      it do
        expect(finder.all).to eq []
      end
    end
    context "with a match" do
      let(:path) { "spec/support" }
      it do
        expect(finder.all).to match_array [ToFactory::User, ToFactory::Project]
      end
    end

    context "no args" do
      it "adds factories for all models" do
        expect(finder.all).to match_array [ToFactory::User, ToFactory::Project]
      end
    end
  end

end


