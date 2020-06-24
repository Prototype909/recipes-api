class Api::V1::RecipesController < ApplicationController
    def index
        @recipes = Recipe.all 
        render json: RecipeSerializer.new(@recipes)
    end

    def show
        @recipe = Recipe.find_by(id: params[:id])
        render json: RecipeSerializer.new(@recipe).serializable_hash
    end

    def create
        @recipe = Recipe.new(recipe_params)
        if @recipe.save
            render json: RecipeSerializer.new(@recipe).serializable_hash
        end
    end

private

    def recipe_params
        params.require(:recipe).permit(:name, :image_url, :description, :instructions, :user_id)
    end
end