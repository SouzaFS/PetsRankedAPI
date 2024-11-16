require "test_helper"

class PetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pet = pets(:one)
  end

  test "should get index" do
    get pets_url, as: :json
    assert_response :success
  end

  test "should create pet" do
    assert_difference("Pet.count") do
      post pets_url, params: { pet: { AdultSize: @pet.AdultSize, Allegiance: @pet.Allegiance, AnimalFriendly: @pet.AnimalFriendly, Bonded: @pet.Bonded, Breed: @pet.Breed, ChildFriendly: @pet.ChildFriendly, Energy: @pet.Energy, Intelligence: @pet.Intelligence, Loyalty: @pet.Loyalty, Noisy: @pet.Noisy, RaiseDifficulty: @pet.RaiseDifficulty, Territorial: @pet.Territorial } }, as: :json
    end

    assert_response :created
  end

  test "should show pet" do
    get pet_url(@pet), as: :json
    assert_response :success
  end

  test "should update pet" do
    patch pet_url(@pet), params: { pet: { AdultSize: @pet.AdultSize, Allegiance: @pet.Allegiance, AnimalFriendly: @pet.AnimalFriendly, Bonded: @pet.Bonded, Breed: @pet.Breed, ChildFriendly: @pet.ChildFriendly, Energy: @pet.Energy, Intelligence: @pet.Intelligence, Loyalty: @pet.Loyalty, Noisy: @pet.Noisy, RaiseDifficulty: @pet.RaiseDifficulty, Territorial: @pet.Territorial } }, as: :json
    assert_response :success
  end

  test "should destroy pet" do
    assert_difference("Pet.count", -1) do
      delete pet_url(@pet), as: :json
    end

    assert_response :no_content
  end
end
