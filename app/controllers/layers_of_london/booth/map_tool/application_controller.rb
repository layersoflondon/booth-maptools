module LayersOfLondon
  module Booth
    module MapTool
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception

        skip_before_action :authenticate_user! rescue nil
        skip_before_action :verify_authenticity_token rescue nil
        skip_after_action  :verify_authorized rescue nil
      end
    end
  end
end
