module Tienda
  class Order < ActiveRecord::Base

    # An array of all the available statuses for an order
    STATUSES = ['building', 'confirming', 'received', 'accepted', 'rejected', 'shipped']

    # The Tienda::User who accepted the order
    #
    # @return [Tienda::User]
    belongs_to :accepter, :class_name => 'Tienda::User', :foreign_key => 'accepted_by'

    # The Tienda::User who rejected the order
    #
    # @return [Tienda::User]
    belongs_to :rejecter, :class_name => 'Tienda::User', :foreign_key => 'rejected_by'

    # Validations
    validates :status, :inclusion => {:in => STATUSES}

    # Set the status to building if we don't have a status
    after_initialize  { self.status = STATUSES.first if self.status.blank? }

    # All orders which have been received
    scope :received, -> {where("received_at is not null")}

    # All orders which are currently pending acceptance/rejection
    scope :pending, -> { where(:status => 'received') }

    # All ordered ordered by their ID desending
    scope :ordered, -> { order(:id => :desc)}

    # All accepted Orders
    scope :accepted, -> { where.not(accepted_at: nil) }

    # Is this order still being built by the user?
    #
    # @return [Boolean]
    def building?
      self.status == 'building'
    end

    # Is this order in the user confirmation step?
    #
    # @return [Boolean]
    def confirming?
      self.status == 'confirming'
    end

    # Has this order been rejected?
    #
    # @return [Boolean]
    def rejected?
      !!self.rejected_at
    end

    # Has this order been accepted?
    #
    # @return [Boolean]
    def accepted?
      !!self.accepted_at
    end

    # Has the order been received?
    #
    # @return [Boolean]
    def received?
      !!self.received_at?
    end


  end
end
