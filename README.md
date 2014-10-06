# hubot-respond

Easily add respond&hear command for hubot.

```
user_name > hubot add respond hoge "fuga"
user_name > hubot hoge
hubot > fuga
```

```
user_name > hubot add hear hoge "fuga"
user_name > hoge
hubot > fuga
```

# Installation

```
npm install git://github.com/kasajei/hubot-respond.git
echo '["hubot-respond"]' > external-scripts.json
```

# Example

```
# add command
user_name > hubot add respond(hear) hoge "fuga"
# list command
user_name > hubot list responds(hears)
# remove command
user_name > hubot rm #{id}
```

# LICENSE
MIT

# AUTHOR
[@kasajei](http://twitter.com/kasajei)