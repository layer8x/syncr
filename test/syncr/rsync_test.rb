require 'test_helper'

describe Syncr::Rsync do
  before do
    reset_test_files
  end

  describe '.rsync' do
    before do
      Syncr::Rsync.rsync(TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH)
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
      Syncr::Rsync.rsync(TEMP_ORIGIN_PATH, to: TEMP_DESTINATION_PATH)
      assert_equal TEMP_DATA, File.read(TEMP_DESTINATION_FILE)
    end
  end

  describe '#rsync' do
    it 'should call .rsync' do
      Syncr::Rsync.new.rsync(TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH)
      assert File.exist?(TEMP_DESTINATION_FILE), "#{TEMP_DESTINATION_FILE} does not exist"
    end
  end
end
