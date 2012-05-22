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
  
  describe "Post 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "" }
      end
      
      it "should not create a user" do
        lambda do                           # Ruby construct that allos us to check that the post :create step doesn't actually create a new user
          post :create, :user => @attr
        end.should_not change(User, :count) # Rspec change method returns the number of users in the database; refers to the Active Record count method
      end
      
      it "should have the right title" do   # makes sure that the title is correct
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
      
      it "should render the 'new' page" do  # checks that a failed signup re-renders the new user page
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i      # /i denotes a case insensitive match
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      
    end
  end
end