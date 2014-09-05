class Ingredient
  attr_reader :name

  def initialize(param_hash)
    @name = param_hash["name"]
    @recipe_id = param_hash["recipe_id"]
    @id = param_hash["id"]
  end
end
