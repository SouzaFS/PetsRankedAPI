class PetsController < ApplicationController
  before_action :set_pet, only: %i[ show update destroy ]

  # GET /pets
  def index
    @pets = Pet.all

    if @pets.any?
      render json: @pets
    else
      head :not_found
    end

  end

  # GET /pets/1
  def show
    render json: @pet
  end

  # POST /pets
  def create
    @pet = Pet.new(pet_params)
    @user = User.find(@pet.user_id)

    if @user.nil?
      render json: @user.errors, status: :not_found
    else
      if @pet.save
        render json: @pet, status: :created, location: @pet
      else
        render json: @pet.errors, status: :unprocessable_entity
      end
    end

  end

  # PATCH/PUT /pets/1
  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pets/1
  def destroy
    @pet.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pet_params
      params.require(:pet).permit(:user_id, :Breed, :Energy, :Allegiance, :Intelligence, :Territorial, :Loyalty, :Bonded, :Noisy, :ChildFriendly, :AnimalFriendly, :RaiseDifficulty, :AdultSize)
    end
end
