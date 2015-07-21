require 'test_helper'

describe Syncr::ListenerSet do
  before do
    @log = []
    @set = Syncr::ListenerSet.new do |from, to|
      @log.push({from: from, to: to})
    end

    @set.add_listener :test, TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH
  end

  describe '#initialize' do
    before do
      @action_proc = proc do |from, to|
        puts 'Blarg!'
      end

      @set = Syncr::ListenerSet.new &@action_proc
    end

    it 'should return a ListenerSet' do
      assert_kind_of Syncr::ListenerSet, @set
    end

    it 'should set the action callback' do
      assert_equal @action_proc, @set.action
    end
  end

  describe '#add_listener' do
    it 'should add listener to listeners' do
      before_size = @set.listeners.size
      @set.add_listener :test_test, TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH
      assert_equal (before_size + 1), @set.listeners.size
    end
  end

  describe '#remove_listener' do
    before do
      @set.add_listener :test_test, TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH
    end

    it 'should remove listener from listeners' do
      before_size = @set.listeners.size
      @set.remove_listener(:test_test)
      assert_equal (before_size - 1), @set.listeners.size
    end
  end

  describe '#start' do
    before do
      @set.start
    end

    it 'should start listeners' do
      @set.listeners.each_value do |listener|
        assert listener.processing?
      end
    end
  end

  describe '#stop' do
    before do
      @set.start
      @set.stop
    end

    it 'should stop listeners' do
      @set.listeners.each_value do |listener|
        refute listener.processing?
      end
    end
  end

  describe '#status' do
    describe 'with a started instance' do
      before do
        @set.start
      end

      it 'should set started status' do
        assert_equal :started, @set.status
      end

      it 'should return false for #stopped?' do
        refute @set.stopped?
      end

      it 'should return true for #started?' do
        assert @set.started?
      end
    end

    describe 'with a stopped instance' do
      it 'should set stopped status' do
        assert_equal :stopped, @set.status
      end

      it 'should return true for #stopped?' do
        assert @set.stopped?
      end

      it 'should return false for #started?' do
        refute @set.started?
      end
    end
  end

  describe '#size' do
    it 'should return listeners length' do
      assert_equal @set.listeners.size, @set.size
    end 
  end
end
