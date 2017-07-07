require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Brett", email: "brtt@example.com",
                        password: "password", password_confirmation: "password")
  end

  test "reject invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef:{chefname: " ",
                                          email: "someemail@example.com"}}
    assert_template 'chefs/edit'
    assert_select 'div'
  end

  test "successfully edit a chef" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: {chef:{chefname: "Blah",
                                          email: "blah@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Blah", @chef.chefname
    assert_match "blah@example.com", @chef.email
  end
end
