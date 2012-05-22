class SessionsController < ApplicationController
  
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    
    if user.nil?                                                # if user is nil create an error message and re-render the signin form
      flash.now[:error] = "Invalid email/password combination."  # had to enter our own error messages here unlike in signup errors because the session isn't an Active Record model
      @title = "Sign in"
      render 'new'
    else                                                         # otherwise sign the user in & redirect to the user's show page
      sign_in user
      redirect_to user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
