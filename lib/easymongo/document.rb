# The mongodb document

module Easymongo
  class Document

    # Takes a BSON::Document
    def initialize(doc)

      # Replace _id with id
      doc['id'] = doc.delete('_id')

      # Convert all BSON::ObjectId to string
      doc.each{|k, v| doc[k] = v.to_s if v.is_a?(BSON::ObjectId)}

      # Write variables
      doc.each{|k, v| attr(k, v)}
    end

    # Get bson id
    def bson_id
      @bson_id ||= BSON::ObjectId.from_string(@id)
    end

    # Creation date
    def date
      bson_id.generation_time
    end

    # Dynamically write value
    def method_missing(name, *args, &block)
      return attr(name[0..-2], args.first) if args.size == 1 and name[-1] == '='
    end

    private

    # Create accessor
    def attr(k, v)
      singleton_class.class_eval { attr_accessor k }; send("#{k}=", v)
    end

  end
end
