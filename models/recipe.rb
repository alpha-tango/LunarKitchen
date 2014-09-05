require_relative 'ingredient'

class Recipe
  attr_reader :id, :name, :description, :instructions, :ingredients
  def initialize(param_hash)
    @id = param_hash["id"]
    @name = param_hash["name"]
    @description = param_hash["description"] || "This recipe doesn't have a description."
    @instructions = param_hash["instructions"] || "This recipe doesn't have any instructions."
    @ingredients = param_hash["ingredients"]
  end

  def self.db_connection
    begin
      connection = PG.connect(dbname: 'recipes')
      yield(connection)
    ensure
      connection.close
    end
  end

  def self.fetch_data(query)
    result = Recipe.db_connection do |conn|
      conn.exec(query)
    end
    data = result.to_a
  end

  def self.all
    query = "SELECT * FROM recipes;"
    results = Recipe.fetch_data(query)

    recipes = []
    results.each do |recipe|
      new_recipe = Recipe.new(recipe)
      recipes << new_recipe
    end
    recipes
  end

  def self.find(id)
    query = "SELECT * FROM recipes WHERE id = #{id};"
    results = Recipe.fetch_data(query).first
    #should refactor this to include find method in ingredients?

    sql = "SELECT * FROM ingredients WHERE recipe_id = #{id}"
    ingredients = Recipe.fetch_data(sql)
    results["ingredients"]=[]

    ingredients.each do |ingredient_hash|
      new_ingredient = Ingredient.new(ingredient_hash)
      results["ingredients"] << new_ingredient
    end

    Recipe.new(results)
  end
end
