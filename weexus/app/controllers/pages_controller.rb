class PagesController < ApplicationController
  def howto
    render template: "pages/#{params[:page]}"
  end
end
