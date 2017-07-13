class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :show]
  before_action :require_admin, except: [:show, :index]

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 8)
  end

  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = "Ingredient was successfully created"
      redirec_to ingredient_path(@ingredient)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = "Ingredient was successfully updated"
      redirec_to @ingredient
    else
      render 'edit'
    end
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_chef.admin?)
      flash[:danger] = "Only admin users can perform that action"
      redirec_to ingredients_path
    end
  end
end
