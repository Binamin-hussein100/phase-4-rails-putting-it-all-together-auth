class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :handle_blank

    before_action :authorize
    def index
        recipes = Recipe.all
        render json: recipes, status: :created
    end

    def create
        recipe = Recipe.create!(recipe_params)
        if recipe.valid?
            render json: recipe, status: :created
        else 
            render json: {error: recipe.errors.full_messages}, status: :unprocessable_entity
        end
    end

    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user)
    end

    def handle_blank(invalid)
        render json: {error: invalid.record.errors}, status: :unprocessable_entity
    end

    def authorize
        render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id
    end
end
