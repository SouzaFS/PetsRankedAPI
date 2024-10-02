require 'swagger_helper'

RSpec.describe 'api/pets', type: :request do
    
    path '/pets' do
        
        get 'Get all Pets' do
            tags 'Pets'
            produces 'application/json'
            
            response '200', 'Success' do
                run_test!
            end
        end
        
        post 'Creates a Pet' do
            tags 'Pets'
            consumes 'application/json'
            parameter name: :pet, in: :body, schema: {
                type: :object,
                properties: {
                  Breed: { type: :string },
                  Energy: { type: :integer },
                  Allegiance: { type: :integer },
                  Intelligence: { type: :integer },
                  Territorial: { type: :integer },
                  Loyalty: { type: :integer },
                  Bonded: { type: :integer },
                  Noisy: { type: :integer },
                  ChildFriendly: { type: :integer },
                  AnimalFriendly: { type: :integer },
                  RaiseDifficulty: { type: :integer },
                  AdultSize: { type: :integer }
                },
                required: [ 'Breed' , 'Energy' , 'Allegiance' , 'Intelligence' , 'Territorial' , 'Loyalty' , 'Bonded' , 'Noisy' , 'ChildFriendly' , 'AnimalFriendly' , 'RaiseDifficulty' , 'AdultSize' ]
            }

            response '201', 'Pet Created' do
                let(:user) { { Breed: 'breed' , Energy: 1 , Allegiance: 1 , Intelligence: 1 , Territorial: 1 , Loyalty: 1 , Bonded: 1 , Noisy: 1 , ChildFriendly: 1 , AnimalFriendly: 1, RaiseDifficulty: 1, AdultSize: 1 } }
                run_test!
            end

            response '422', 'Invalid Request' do
                let(:user) { { Breed: 'breed' } }
                run_test!
            end
        end        
    end

    path '/pets/{id}' do
        
        get 'Get Pet' do
            tags 'Pets'
            produces 'application/json'
            parameter name: :id, in: :path, type: :string

            response '200', 'Success' do
                schema type: :object,
                properties: {
                  Breed: { type: :string },
                  Energy: { type: :integer },
                  Allegiance: { type: :integer },
                  Intelligence: { type: :integer },
                  Territorial: { type: :integer },
                  Loyalty: { type: :integer },
                  Bonded: { type: :integer },
                  Noisy: { type: :integer },
                  ChildFriendly: { type: :integer },
                  AnimalFriendly: { type: :integer },
                  RaiseDifficulty: { type: :integer },
                  AdultSize: { type: :integer }
                },
                required: [ 'Breed' , 'Energy' , 'Allegiance' , 'Intelligence' , 'Territorial' , 'Loyalty' , 'Bonded' , 'Noisy' , 'ChildFriendly' , 'AnimalFriendly' , 'RaiseDifficulty' , 'AdultSize' ]

                let(:id) { User.create(Breed: 'breed' , Energy: 1 , Allegiance: 1 , Intelligence: 1 , Territorial: 1 , Loyalty: 1 , Bonded: 1 , Noisy: 1 , ChildFriendly: 1 , AnimalFriendly: 1, RaiseDifficulty: 1, AdultSize: 1).id }
                run_test!
            end

            response '404', 'Not Found' do
                let(:id) { 'invalid' }
                run_test!
            end
        
        end

        put 'Update Pet' do
            tags 'Pets'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :string

            produces 'application/json'
            parameter name: :pet, in: :body, schema: {
                type: :object,
                properties: {
                  Breed: { type: :string },
                  Energy: { type: :integer },
                  Allegiance: { type: :integer },
                  Intelligence: { type: :integer },
                  Territorial: { type: :integer },
                  Loyalty: { type: :integer },
                  Bonded: { type: :integer },
                  Noisy: { type: :integer },
                  ChildFriendly: { type: :integer },
                  AnimalFriendly: { type: :integer },
                  RaiseDifficulty: { type: :integer },
                  AdultSize: { type: :integer }
                },
                required: [ 'Breed' , 'Energy' , 'Allegiance' , 'Intelligence' , 'Territorial' , 'Loyalty' , 'Bonded' , 'Noisy' , 'ChildFriendly' , 'AnimalFriendly' , 'RaiseDifficulty' , 'AdultSize' ]
            }
            
            response '200', 'Success' do
                schema type: :object,
                properties: {
                  Breed: { type: :string },
                  Energy: { type: :integer },
                  Allegiance: { type: :integer },
                  Intelligence: { type: :integer },
                  Territorial: { type: :integer },
                  Loyalty: { type: :integer },
                  Bonded: { type: :integer },
                  Noisy: { type: :integer },
                  ChildFriendly: { type: :integer },
                  AnimalFriendly: { type: :integer },
                  RaiseDifficulty: { type: :integer },
                  AdultSize: { type: :integer }
                }

                let(:id) { User.create(Breed: 'breed' , Energy: 1 , Allegiance: 1 , Intelligence: 1 , Territorial: 1 , Loyalty: 1 , Bonded: 1 , Noisy: 1 , ChildFriendly: 1 , AnimalFriendly: 1, RaiseDifficulty: 1, AdultSize: 1).id }
                let(:user) { { Breed: 'breed' , Energy: 1 , Allegiance: 1 , Intelligence: 1 , Territorial: 1 , Loyalty: 1 , Bonded: 1 , Noisy: 1 , ChildFriendly: 1 , AnimalFriendly: 1, RaiseDifficulty: 1, AdultSize: 1 } }

                run_test!
            end

            response '404', 'Not Found' do
                let(:id) { 'invalid' }

                run_test!
            end

            response '422', 'Invalid Request' do
                let(:user) { { Name: 'name' } }
                run_test!
            end

        end

        
        delete 'Delete Pet' do
            tags 'Pets'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :string
            
            response '204', 'No Content' do
                let(:id) { User.create(Breed: 'breed' , Energy: 1 , Allegiance: 1 , Intelligence: 1 , Territorial: 1 , Loyalty: 1 , Bonded: 1 , Noisy: 1 , ChildFriendly: 1 , AnimalFriendly: 1, RaiseDifficulty: 1, AdultSize: 1).id }
                
                run_test!
            end

            response '404', 'Not Found' do
                let(:id) { 'invalid' }

                run_test!
            end
        end


    end

end
