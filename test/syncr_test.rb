require 'test_helper'

describe Syncr do
  it 'should have a version number' do
    refute_nil ::Syncr::VERSION
  end

  describe 'class methods' do
    describe '::rsync' do
      before do
        reset_test_files
        Syncr.rsync(TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH)
      end

      it 'should create files' do
        assert File.exists?(TEMP_DESTINATION_FILE), "#{TEMP_DESTINATION_FILE} does not exist"
      end

      it 'should copy contents' do
        assert_equal File.read(TEMP_ORIGIN_FILE), File.read(TEMP_DESTINATION_FILE)
      end

      it 'should not mess with original file' do
        assert_equal TEMP_DATA, File.read(TEMP_ORIGIN_FILE)
      end

      it 'should support alternative syntax' do
        reset_test_files
        Syncr.rsync(TEMP_ORIGIN_PATH, to: TEMP_DESTINATION_PATH)
        assert_equal TEMP_DATA, File.read(TEMP_DESTINATION_FILE)
      end
    end
  end

  describe 'instance' do
    before do
      @syncr = Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
    end

    describe 'directory accessors' do
      it 'should set directory getters' do
        assert_respond_to @syncr, :local_directory
        assert_respond_to @syncr, :external_directory
      end

      it 'should set directory setters' do
        assert_respond_to @syncr, :local_directory=
        assert_respond_to @syncr, :external_directory=
      end

      it 'should set the proper options using getters and setters' do
        dir = '/path/to/some/directory'

        @syncr.local_directory = dir
        assert_equal dir, @syncr.options[:local]

        @syncr.options[:external] = dir
        assert_equal dir, @syncr.external_directory
      end
    end

    describe '#initialize' do
      it 'should raise ArgumentError when there is not a local directory set' do
        assert_raises ArgumentError do
          Syncr.new(external: TEMP_DESTINATION_PATH)
        end
      end

      it 'should raise ArgumentError when there is not a external directory set' do
        assert_raises ArgumentError do
          Syncr.new(local: TEMP_ORIGIN_PATH)
        end
      end
    end

    describe '#rsync' do
      before do
        reset_test_files
      end

      it 'should call rsync class method' do
        @syncr.rsync TEMP_ORIGIN_PATH, to: TEMP_DESTINATION_PATH
        assert_equal TEMP_DATA, File.read(TEMP_DESTINATION_FILE)
      end
    end

    describe 'listeners' do
      it 'should contain one listeners' do
        assert_equal 1, @syncr.listeners.size
      end

      it 'should contain two listeners for two-way syncing' do
        s = Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH, two_way_sync: true)
        assert_equal 2, s.listeners.size
      end

      it 'should start listeners' do
        @syncr.start
        @syncr.listeners.each_value do |listener|
          assert listener.processing?
        end
        @syncr.stop
      end

      it 'should stop listeners' do
        @syncr.start
        @syncr.stop
        @syncr.listeners.each_value do |listener|
          refute listener.processing?
        end
      end
    end
  end
end
