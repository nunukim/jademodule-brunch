# jademodule-brunch

[Brunch](http://brunch.io) plugin building [Jade](http://jade-lang.com) templates as [RequireJS](http://requirejs.org)-like module

# Usage

Build a jade module,

  // hoge.jdlib
  - exports.btn = function(label)
    button= name

  - exports.text = function(name, value)
    input(type='text', name=name, value=value)

then,

  // view.js
  var hoge = require('./hoge');
  
  $('body').append(hoge.text('Click me!'));
  $('body').append(hoge.btn('Click me!'));
