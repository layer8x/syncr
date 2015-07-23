require 'test_helper'

describe Syncr::Listener do
  describe 'class methods' do
    describe '.start' do
      before do
        @listener = Syncr::Listener.start(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
      end

      after do
        @listener.stop
      end

      it 'should return an instance of Listener' do
        assert_kind_of Syncr::Listener, @listener
      end

      it 'should start listeners' do
        assert @listener.listeners.started?
      end
    end
  end

  describe 'instance' do
    describe '#initialize' do
      before do
        reset_test_files
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

      it 'should add one listener' do
        @listener = Syncr::Listener.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
        assert_equal 1, @listener.listeners.size
      end

      it 'should add two listeners for two-way syncing' do
        Dir.mkdir(TEMP_DESTINATION_PATH)
        @listener = Syncr::Listener.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH, two_way_sync: true)
        assert_equal 2, @listener.listeners.size
      end
    end

    describe '#start' do
      before do
        reset_test_files
        @listener = Syncr::Listener.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
      end

      after do
        @listener.stop
      end

      it 'should start listeners' do
        @listener.start
        assert @listener.listeners.started?
      end
    end

    describe '#stop' do
      before do
        reset_test_files
        @listener = Syncr::Listener.new(local: TEMP_ORIGIN_PATH, external: TEMP_DESTINATION_PATH)
      end

      it 'should be stopped by default' do
        assert @listener.listeners.stopped?
      end

      it 'should stop listeners after starting' do
        @listener.start
        @listener.stop
        assert @listener.listeners.stopped?
      end
    end
  end
end
