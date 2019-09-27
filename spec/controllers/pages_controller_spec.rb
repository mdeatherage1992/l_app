require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  context 'GET #get_reviews' do
   it 'should success and render to json response' do
      get :get_reviews,  params: { link:'https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183' }
      expect(response).to have_http_status(200)
      #expect(response).to render_template :get_reviews
      expect(response.content_type).to eq "application/json"
      ActiveSupport::JSON.decode(response.body).should_not be_nil
   end
   ### incomplete url
   it 'returns status code 422 with error' do
   	 	get :get_reviews, params: { link:'https://www.lendingtree.com/reviews/' }
        expect(response).to have_http_status(422)
    end
    ### test case for no url
    it 'returns status code 422' do
   	 	get :get_reviews
        expect(response).to have_http_status(422)
    end
 end
end
