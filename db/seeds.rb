if ActiveRecord::Base.connection.table_exists? 'articles'
  Article.where(title: 'I love Ruby!', category: 'ruby').first_or_create
  Article.where(title: 'I love Elasticsearch!', category: 'elasicsearch').first_or_create
  Article.where(title: "Why it's always sunny in California", category: 'other').first_or_create
end
