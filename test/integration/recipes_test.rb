require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Bobby", email: "bobby@example.com", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "Corn Pudding", description: "My grannys is the best!", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "Hot Dogs", description: "Pot, grill, however you like")
    @recipe2.save
  end

  test "should get recipe index" do
    get recipes_path
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should get recipes show" do
    sign_in_as(@chef, "password")
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
    assert_select 'a[href=?]', recipes_path, text: "Back"
    assert_select 'a[href=?]', edit_recipe_path(@recipe), text: "Edit"
    assert_select 'a[href=?]', recipe_path(@recipe), text: "Delete"
  end

  test "create new valid recipe" do
    sign_in_as(@chef, "password")
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "Greens"
    description_of_recipe = "Wash them, trim them, add meat, water and greens in a pot. Boil down. "
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe,
                                      description: description_of_recipe}}
      end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end

  test "reject invalid recipe submissions" do
    sign_in_as(@chef, "password")
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: " ", description: " " } }
    end
    assert_template 'recipes/new'
    assert_select 'div'
  end
end
