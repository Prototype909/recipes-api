class Api::V1::RecipesController < ApplicationController
    # before_action :logged_in?, except [:index, :show]

    def index
        if params[:user_id]
            @recipes = Recipe.where(user_id: params[:user_id])
        else
            @recipes = Recipe.all
        end
        
        render json: RecipeSerializer.new(@recipes).serialized_json
    end

    def current_user_recipes
        if logged_in?
            @recipes = current_user.recipes
            render json: RecipeSerializer.new(@recipes).serialized_json
        
        else
            render json: {
                notice: "You don't have any recipes, yet."
            }
        end
    end

    def show
        @recipe = Recipe.find_by(id: params[:id])
        render json: RecipeSerializer.new(@recipe).serialized_json
    
    end

    def create
        # byebug
        @recipe = current_user.recipes.build(recipe_params)
        # byebug
        if @recipe.save
            render json: RecipeSerializer.new(@recipe).serialized_json, status: :created
        else
            error_resp = {
                error: @recipe.errors.full_messages.to_sentence
            }
            render json: error_resp, status: :unprocessable_entity
        end
    end

private

    def recipe_params
        params.require(:recipe).permit(:name, :image_url, :description, :instructions, :user_id, ingredients_attributes: [:name, :quantity, :unit])
    end
end
