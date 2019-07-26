module LayersOfLondon
  module Booth
    module MapTool
      class ApplicationController < ActionController::Base
        include Pundit

        protect_from_forgery with: :exception

        after_action :verify_authorized

        skip_before_action :authenticate_user! rescue nil
        skip_before_action :verify_authenticity_token rescue nil

        # def current_user
        #   byebug
        #   main_app.scope.request.env['warden'].user
        # end
      end
    end
  end
end
