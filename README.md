# JSHintMate

Easy JSHinting for TextMate2

## Installation

Install Node.js and [JSHint](http://www.jshint.com/install/) (globally with `-g`)

* Once JSHint is installed, you'll need to add it's path to your TextMate `$PATH` under TextMate > Perferences > Variables.
* For average Node installs, JSHint is installed in `/usr/local/bin`. If it's not there, you can use `which jshint` to find the path.

Then install the bundle:

```sh
mkdir -p ~/Library/Application\ Support/Avian/Bundles
cd ~/Library/Application\ Support/Avian/Bundles
git clone git://github.com/eoneill/JSHintMate.tmbundle.git
```

## Usage

* `⌘S` - quick Hinting on save
* `⌘K` - detailed Hinting

## Lots of inspiration
... and borrowed code :)

* https://github.com/uipoet/sublime-jshint
* https://github.com/fgnass/jshint.tmbundle
* https://github.com/rondevera/jslintmate
