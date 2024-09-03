require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
    
    path '/users' do
        
        get 'Get all Users' do
            tags 'Users'
            produces 'application/json'
            
            response '200', 'Success' do
                run_test!
            end
        end
        
        post 'Creates an User' do
            tags 'Users'
            consumes 'application/json'
            parameter name: :user, in: :body, schema: {
                type: :object,
                properties: {
                    Name: { type: :string },
                    Surname: { type: :string },
                    Username: { type: :string },
                    Email: { type: :string },
                    Password: { type: :string },
                    Phone: { type: :string }
                },
                required: [ 'Name' , 'Surname' , 'Username' , 'Email' , 'Password' , 'Phone' ]
            }

            response '201', 'User Created' do
                let(:user) { { Name: 'name' , Surname: 'surname' , Username: 'username' , Email: 'email' , Password: 'password' , Phone: 'phone' } }
                run_test!
            end

            response '422', 'Invalid Request' do
                let(:user) { { Name: 'name' } }
                run_test!
            end
        end        
    end

    path '/users/{id}' do
        
        get 'Get User' do
            tags 'Users'
            produces 'application/json'
            parameter name: :id, in: :path, type: :string

            response '200', 'Success' do
                schema type: :object,
                    properties: {
                        Name: { type: :string },
                        Surname: { type: :string },
                        Username: { type: :string },
                        Email: { type: :string },
                        Password: { type: :string },
                        Phone: { type: :string }
                    },
                    required: [ 'Name' , 'Surname' , 'Username' , 'Email' , 'Password' , 'Phone' ]

                let(:id) { User.create(Name: 'name' , Surname: 'surname' , Username: 'username' , Email: 'email' , Password: 'password' , Phone: 'phone').id }
                run_test!
            end

            response '404', 'Not Found' do
                let(:id) { 'invalid' }
                run_test!
            end
        
        end

        put 'Update User' do
            tags 'Users'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :string

            produces 'application/json'
            parameter name: :user, in: :body, schema: {
                type: :object,
                properties: {
                    Name: { type: :string },
                    Surname: { type: :string },
                    Username: { type: :string },
                    Email: { type: :string },
                    Password: { type: :string },
                    Phone: { type: :string }
                },
                required: [ 'Name' , 'Surname' , 'Username' , 'Email' , 'Password' , 'Phone' ]
            }
            
            response '200', 'Success' do
                schema type: :object,
                    properties: {
                        Name: { type: :string },
                        Surname: { type: :string },
                        Username: { type: :string },
                        Email: { type: :string },
                        Password: { type: :string },
                        Phone: { type: :string }
                    }

                let(:id) { User.create(Name: 'name' , Surname: 'surname' , Username: 'username' , Email: 'email' , Password: 'password' , Phone: 'phone').id }
                let(:user) { { Name: 'name' , Surname: 'surname' , Username: 'username' , Email: 'email' , Password: 'password' , Phone: 'phone' } }

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

        
        delete 'Delete User' do
            tags 'Users'
            consumes 'application/json'
            parameter name: :id, in: :path, type: :string
            
            response '204', 'No Content' do
                let(:id) { User.create(Name: 'name' , Surname: 'surname' , Username: 'username' , Email: 'email' , Password: 'password' , Phone: 'phone').id }
                
                run_test!
            end

            response '404', 'Not Found' do
                let(:id) { 'invalid' }

                run_test!
            end
        end


    end

end
