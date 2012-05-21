require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user  # test uses symbol :show instead of string 'show', diff from other tests. get 'show' and get :show do the same thing but MH prefers to use symbols when testing the canonical REST actions
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user  # as above, the value of the hash key :id is not the user's id attribute @user.id, but the user object itself. We could use the code get :show, :id => @user.id to accomplish the same thing, but in this context Rails automatically converts the user object to the corresponding id
      assigns(:user).should == @user  # assigns(:user) is a facility provided by rspec which takes in a symbol argument & returns the value of the corresponding instance variable (in this case @user) in the controller action (in this case the show action of the Users controller)
    end
  
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name) # verifies presence of title tags containing user's name 
    end
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name) # verifies presence of h1 tags containing user's name (not always a good idea to make html tests this specific as we don't want to constrain the layout too much)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar") # ensures that image tag is inside h1 tag & have_selector can take a :class option to test the CSS class of the element
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end
end
