# README

### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 3.2.2
- Rails 7.0.7
- PostgreSQL

##### 1. Check out the repository

```
git@github.com:luvcjssy/url-shortener-service.git
```

##### 2. Go to project directory

```
cd <path_to_project>
```

##### 3. Install gem
```
bundle install
```

##### 4. Create database.yml file

Edit the database configuration as required.

```
config/database.yml
```

##### 5. Create and setup the database

Run the following commands to create and setup the database.

```
rails db:create
rails db:migrate
```

##### 6. Start the Rails server

You can start the rails server using the command given below.

```
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

Or you can try on demo environment: https://url-shortener-service-8064270102f2.herokuapp.com

### APIs doc

APIs are hosted on: https://url-shortener-service-8064270102f2.herokuapp.com

1. POST api/encode: Encode the original url
   - Request:
        ```
        curl --location 'https://url-shortener-service-8064270102f2.herokuapp.com/api/encode' --header 'Content-Type: application/json' --data '{"original_url": "https://oivan.com"}'
        ```
   - Response:
        ```
        {
          "success": true,
          "data": {
            "shortener_url": "https://url-shortener-service-8064270102f2.herokuapp.com/b1B7Yx"
          }
        }
        ```

2. POST api/decode: Decode the code to original url
   - Request
        ```
        curl --location 'https://url-shortener-service-8064270102f2.herokuapp.com/api/decode' --header 'Content-Type: application/json' --data '{"code": "b1BWfF"}'
        ```
   - Response:
        ```
        {
          "success": true,
          "data": {
            "original_url": "https://oivan.com"
          }
        }
        ```