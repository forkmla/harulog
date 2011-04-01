class PagesController < ApplicationController
  def home
    @title = "Harulog"
  end

  def profile
    @title = "Profile"
  end

  def setting
    @title = "Settings"
  end

  def logout
  end

end
