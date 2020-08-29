# sai

Sai, a public Zoom meeting database.

## Requirements
You must have any recent version of Crystal lang

A MongoDB instance with a database and collection named `sai`

libmongoc-dev libmongoc-1.0-0 libmongoclient-dev for [kimvex/mongodb-crystal](https://github.com/kimvex/mongodb-crystal)
+ If on Ubuntu `$ sudo apt install libmongoc-dev libmongoc-1.0-0 libmongoclient-dev`


## Installation

```
$ git clone https://github.com/Domterion/sai.git
$ cd sai
$ shards install 
```

You will have to edit the `config.cr.example`, change the mongo uri to your instance with a collection and db called `sai`. Change the name to `config.cr` 

```
$ shards build && ./bin/sai
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/domterion/sai/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [domterion](https://github.com/domterion) - creator and maintainer
