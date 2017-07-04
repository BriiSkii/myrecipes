require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Bobby", email: "bobby@example.com", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "French Toast", description: "Milk, Eggs, Cinnamon, Nutmeg. Coat and fry", chef: @chef)
  end

  test "reject invalid recipe update" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: {recipe:{name: " ",
                                          description: "Some description"}}
    assert_template 'recipes/edit'
    assert_select 'div'
  end

  test "successfully edit a recipe" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "Updated Recipe Name"
    updated_description = "Updated recipe description"
    patch recipe_path(@recipe), params: {recipe:{name: updated_name,
                                          description: updated_description}}
    assert_redirected_to @recipe
    follow_redirect!
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end


end
