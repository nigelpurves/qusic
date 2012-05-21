module UsersHelper
  
  def gravatar_for(user, options = { :size => 50})                    # 2nd half of function definition sets a default option for the size of the Gravatar to 50x50 (only need one number as gravatars are square)
    gravatar_image_tag(user.email.downcase, :alt => user.name,        # assigns the user's name if the image can't be loaded
                                            :class => "gravatar",     # sets the CSS class of the resulting gravatar
                                            :gravatar => options)     # passes the options hash using the :gravatar key, which according to the gravatar_image_tag gem documentation is how to set the options for gravatar_image_tag
  end
end
