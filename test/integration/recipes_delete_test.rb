require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Bobby", email: "bobby@example.com", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Corn Pudding", description: "My grannys is the best!", chef: @chef)
  end

  test "successfully delete a recipe" do
    sign_in_as(@chef, "password")
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: "Delete"
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
