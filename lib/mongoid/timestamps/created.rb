# encoding: utf-8
require "mongoid/timestamps/created/short"

module Mongoid
  module Timestamps
    # This module handles the behaviour for setting up document created at
    # timestamp.
    module Created
      extend ActiveSupport::Concern

      included do
        include Mongoid::Timestamps::Timeless

        field :created_at, type: Time
        set_callback :create, :before, :set_created_at
      end

      # Update the created_at field on the Document to the current time. This is
      # only called on create.
      #
      # @example Set the created at time.
      #   person.set_created_at
      def set_created_at

        self.logger.info "Check before action: timeless is #{timeless}"
        self.logger.info "Check before action: created_at before is #{created_at}"
        self.logger.info "Check before action: updated_at_changed is #{updated_at_changed?}"

        if !timeless? && !created_at
          time = Time.now.utc

          self.logger.info "Check inside action: time is #{time}"

          self.updated_at = time if is_a?(Updated) && !updated_at_changed?
          self.created_at = time
        end

        self.logger.info "Check after action: created_at is #{created_at}"
        self.logger.info "Check after action: updated_at is #{updated_at}"

        self.class.clear_timeless_option
      end
    end
  end
end
