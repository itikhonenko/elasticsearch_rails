module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # Every time our entry is created, updated, or deleted, we update the index accordingly.
    after_commit on: %i[create update] do
      __elasticsearch__.index_document
    end

    after_commit on: %i[destroy] do
      __elasticsearch__.delete_document
    end

    # We serialize our model's attributes to JSON, including only the title and category fields.
    def as_indexed_json(_options = {})
      as_json(only: %i[title category])
    end

    # Here we define the index configuration
    settings settings_attributes do
      # We apply mappings to the title and category fields.
      mappings dynamic: false do
        # for the title we use our own autocomplete analyzer that we defined below in the settings_attributes method.
        indexes :title, type: :text, analyzer: :autocomplete
        # the category must be of the keyword type since we're only going to use it to filter articles.
        indexes :category, type: :keyword
      end
    end

    def self.search(query, filters)
      # lambda function adds conditions to the search definition.
      set_filters = lambda do |context_type, filter|
        @search_definition[:query][:bool][context_type] |= [filter]
      end

      @search_definition = {
        # we indicate that there should be no more than 5 documents to return.
        size: 5,
        # we define an empty query with the ability to dynamically change the definition
        # Query DSL https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html
        query: {
          bool: {
            must: [],
            should: [],
            filter: []
          }
        }
      }

      # match all documents if the query is blank.
      if query.blank?
        set_filters.call(:must, match_all: {})
      else
        set_filters.call(
          :must,
          match: {
            title: {
              query: query,
              # fuzziness means you can make one typo and still match your document.
              fuzziness: 1
            }
          }
        )
      end

      # the system will return only those documents that pass this filter
      set_filters.call(:filter, term: { category: filters[:category] }) if filters[:category].present?

      # and finally we pass the search query to Elasticsearch.
      __elasticsearch__.search(@search_definition)
    end
  end

  class_methods do
    def settings_attributes
      {
        index: {
          analysis: {
            analyzer: {
              # we define a custom analyzer with the name autocomplete.
              autocomplete: {
                # type should be custom for custom analyzers.
                type: :custom,
                # we use a standard tokenizer.
                tokenizer: :standard,
                # we apply two token filters.
                # autocomplete filter is a custom filter that we defined above.
                # and lowercase is a built-in filter.
                filter: %i[lowercase autocomplete]
              }
            },
            filter: {
              # we define a custom token filter with the name autocomplete.

              # Autocomplete filter is of edge_ngram type. The edge_ngram tokenizer divides the text into smaller parts (grams).
              # For example, the word “ruby” will be split into [“ru”, “rub”, “ruby”].

              # edge_ngram is useful when we need to implement autocomplete functionality. However, the so-called "completion suggester" - is another way to integrate the necessary options.
              autocomplete: {
                type: :edge_ngram,
                min_gram: 2,
                max_gram: 25
              }
            }
          }
        }
      }
    end
  end
end
