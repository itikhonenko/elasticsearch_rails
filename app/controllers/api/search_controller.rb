module Api
  class SearchController < ApplicationController
    def search
      results = Article.search(search_params[:q], search_params)

      articles = results.map do |r|
        r['_source'].merge('id': r['_id'])
      end

      render json: { articles: articles }, status: :ok
    end

    private

    def search_params
      params.permit(:q, :category)
    end
  end
end
