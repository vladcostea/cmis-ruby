require 'upnxt_storage_lib_cmis_ruby/model'
require_relative 'repository_home'

describe Model::Folder do

  before do
    @repo = create_repository('test_folder')
  end

  after do
    delete_repository('test_folder')
  end

  it 'create document' do
    new_object = @repo.new_document
    new_object.name = 'doc1'
    new_object.object_type_id = 'cmis:document'
    new_object.set_content(StringIO.new('apple is a fruit'), 'text/plain', 'apple.txt')
    object = @repo.root.create(new_object)
    object.should be_a_kind_of Model::Document
    object.name.should eq 'doc1'
    object.content_stream_mime_type.should eq 'text/plain'
    object.content_stream_file_name.should eq 'apple.txt'
    object.content.should eq 'apple is a fruit'
    object.delete
  end

  it 'create folder' do
    new_object = @repo.new_folder
    new_object.name = 'folder1'
    new_object.object_type_id = 'cmis:folder'
    object = @repo.root.create(new_object)
    object.should be_a_kind_of Model::Folder
    object.name.should eq 'folder1'
    object.delete
  end
end
