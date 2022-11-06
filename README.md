# Elasticsearch with Rails integration

## Full Text Search With Autocompletion using Ruby on Rails API along with Elasticsearch, Kibana and Docker
[Full Article](https://tihandev.com/how-to-integrate-elasticsearch-with-ruby-on-rails)
## Quick start

1. Install Docker & Docker Compose
2. Run `docker-compose build`
3. Run `docker-compose up`
## Links
|Name|Link|
|---|---|
|API|http://localhost:3000|
|Elasticsearch|http://localhost:9200|
|Kibana|http://localhost:5601|

## Commands (docker-compose)
|Command|Alias|Description|
|---|---|---|
|`docker-compose up`|`dcup`| starts dev environment (all services)
|`docker-compose stop`|`dcstop`| stops dev environment (all services)
|`docker-compose up backend`|`dcup backend`| starts backend (API) only
|`docker-compose up backend client`|`dcup backend client`| starts both backend & client
|`docker-compose ps`|`dcps`| shows status of running containers
|`docker-compose exec backend bash`|`dce backend bash`| opens terminal inside container
|`docker-compose exec backend rails c`|`dce backend rails c`| opens rails console inside container
|`docker-compose exec backend {command}`|`dce backend {command}`| to run any command inside a particular container
|`docker-compose run backend {command}`|`dcr backend {command}`| to run any command inside a particular container and to start container automatically

* to use aliases `nano ~/.zshrc` and add `plugins=(docker-compose ...)`
