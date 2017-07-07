require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Brett", email: "brtt@example.com",
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Gayle", email: "gayle@example.com",
                        password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "Evie", email: "eve@example.com",
                        password: "password", password_confirmation: "password", admin: true)
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

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "Misty", email: "misty@example.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Misty", @chef.chefname
    assert_match "misty@example.com", @chef.email
  end

  test "redirect edit attempt by non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "Charles"
    updated_email = "charles@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email }}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Brett", @chef.chefname
    assert_match "brtt@example.com", @chef.email
  end
end
