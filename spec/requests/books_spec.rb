require 'rails_helper'

describe 'Books API', type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: 'Geroge', last_name: 'Orwell', age: 64) }
  let(:second_author) { FactoryBot.create(:author, first_name: 'H.G.', last_name: 'Wells', age: 55) }
      
  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1984', author: first_author)
      FactoryBot.create(:book, title: 'The Time Machine', author: second_author)
    end
    it 'return all books' do
      get '/api/v1/books' # GET /api/v1/books
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(2)
      expect(response_body).to eq([
        {
          "id"=>1,
          "title"=>"1984",
          "author_name"=>"Geroge Orwell",
          "author_age"=>64
        },
        {
          "id"=>2,
          "title"=>"The Time Machine",
          "author_name"=>"H.G. Wells",
          "author_age"=>55
        }
      ])
    end

    it 'returns a subset of books based on limit' do
      get '/api/v1/books', params: { limit: 1 }
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq([
        {
          "id"=>1,
          "title"=>"1984",
          "author_name"=>"Geroge Orwell",
          "author_age"=>64
        }
      ])
    end

    it 'returns a subset of books based on pagination and offset' do
      get '/api/v1/books', params: { limit: 1, offset: 1 }
      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
      expect(response_body).to eq([
        {
          "id"=>2,
          "title"=>"The Time Machine",
          "author_name"=>"H.G. Wells",
          "author_age"=>55
        }
      ])
    end
  end

  describe 'POST /books' do
    it 'post a new book' do
      post '/api/v1/books', params: { 
        book: { title: '1984' },
        author: { first_name: 'George', last_name: 'Orwell', age: '64' }
      }
      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          'id' => 1,
          'title' => '1984',
          'author_name' => 'George Orwell',
          'author_age' => 64
        }
      )
    end
  end

  describe 'DELETE /books/:id' do
    it 'Delete a book' do
      book = FactoryBot.create(:book, title: '1984', author: first_author)
      delete "/api/v1/books/#{book.id}"
      expect(response).to have_http_status(:no_content)
    end
  end
end