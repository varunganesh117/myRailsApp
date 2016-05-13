require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Varun Ganesh", email: "varun@abc.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end  
  
  test "email field should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each { |address|
      @user.email = address
      assert @user.valid?, "#{address} must be valid"
    }
  end
  
  test "email field should not accept invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each { |address|
      @user.email = address
      assert_not @user.valid?, "#{address} must be rejected"
    }
  end
  
  test "email addresses should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end
  
  test "email addresses should be downcased" do
    @user.email = "fOo@BAR.COm"
    @user.save
    assert @user.reload.email == "foo@bar.com", "#{@user.email} is not all downcase"
  end
  
  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
   assert_not @user.authenticated?("")
  end
end
