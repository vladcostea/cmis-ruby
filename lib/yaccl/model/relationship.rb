module YACCL
  module Model
    class Relationship < Object
      attr_reader :source_id
      attr_reader :target_id

      def initialize(repository_id, raw={})
        super
        @source_id = @properties['cmis:sourceId']
        @target_id = @properties['cmis:targetId']
      end

      def source
        Object.create(Services.get_object(repository_id, source_id, nil, false, nil, nil, false, false))
      end

      def target
        Object.create(Services.get_object(repository_id, target_id, nil, false, nil, nil, false, false))
      end
    end
  end
end
