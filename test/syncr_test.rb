require 'test_helper'

describe Syncr do
  describe 'v0.2.x API' do
    describe '.rsync' do
      before do
        reset_test_files
      end

      it 'should call Rsync.rsync' do
        Syncr.rsync(TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH)
        assert File.exist?(TEMP_DESTINATION_FILE), "#{TEMP_DESTINATION_FILE} does not exist"
      end
    end

    describe '.listen' do
      before do
        reset_test_files
        @listener = Syncr.listen(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
      end

      after do
        @listener.stop
      end

      it 'should return Listener instance' do
        assert_kind_of Syncr::Listener, @listener
      end

      it 'should start the listeners' do
        assert @listener.listeners.started?
      end
    end

    describe '.start' do
      it 'should be deprecated' do
        out, err = capture_io do
          Syncr.start(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
        end
        refute_empty err
      end
    end

    describe '.new' do
      it 'should be deprecated' do
        out, err = capture_io do
          Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
        end
        refute_empty err
      end
    end
  end

  describe 'v0.1.x API' do
    describe 'class methods' do
      describe '::rsync' do
        before do
          reset_test_files
          Syncr.rsync(TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH)
        end

        it 'should create files' do
          assert File.exist?(TEMP_DESTINATION_FILE), "#{TEMP_DESTINATION_FILE} does not exist"
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
      describe '#initialize' do
        before do
          @syncr = Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
        end

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
          @syncr = Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
        end

        it 'should call rsync class method' do
          @syncr.rsync TEMP_ORIGIN_PATH, to: TEMP_DESTINATION_PATH
          assert_equal TEMP_DATA, File.read(TEMP_DESTINATION_FILE)
        end
      end

      describe 'listeners' do
        before do
          reset_test_files
        end

        it 'should contain one listeners' do
          @syncr = Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
          assert_equal 1, @syncr.listeners.size
        end

        it 'should contain two listeners for two-way syncing' do
          Dir.mkdir(TEMP_DESTINATION_PATH)
          @syncr = Syncr.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH, two_way_sync: true)
          assert_equal 2, @syncr.listeners.size
        end
      end
    end
  end
end
