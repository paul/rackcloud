
module RackCloud::Datapathy
  module ModelExtensions

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods

      def base_url(base_url)
        if base_url
          @base_url = base_url
        else
          @base_url
        end
      end

    end

  end
end
