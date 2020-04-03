class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  
  #todo: working on gracefully handling auth failure
  # Overwrite unverified request handler to force a refresh / redirect.
  #def handle_unverified_request
  #  super # call the default behaviour, including Devise override
  #  throw :warden, redirect: request.referer || request.url
  #end

end
