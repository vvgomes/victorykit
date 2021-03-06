require 'spec_helper'

describe ApplicationController do
  describe "Current User" do
    context "user is in session" do
      before(:each) do 
         @user = create(:user)
         session[:user_id] = @user.id
      end
      its(:current_user) { should == @user }
    end    
    context "user is not in session" do
      before(:each) do 
         session[:user_id] = nil
      end
      its(:current_user) {should be_nil}
    end
  end

  describe "spinning for different browsers" do
    before(:each) do
      def controller.spin! test_name, goals, options, my_session
        options.last
      end
    end
    context "using chrome" do
      it "should spin" do
        request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1'
        result = controller.spin_if_cool_browser!("some experiment", :some_goal, [true, false])
        result.should be_false
      end
    end
    context "using ie" do
      it "should not spin" do
        request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.0.3705; .NET CLR 1.1.4322)'
        result = controller.spin_if_cool_browser!("some experiment", :some_goal, [true, false])
        result.should be_true
      end
    end
  end
end
