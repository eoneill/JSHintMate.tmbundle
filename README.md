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

* `⌘S` - quick Hinting on save (actually bound to document save, not specifically the key bind)
* `⌘K` - detailed Hinting

## Configuration

Make it work your way. Set these configuration options in your project `.tm_properties`:

* `TM_JSHINTMATE_PEVIEW_MAX` - max number of items to show in the preview (on save) (default: `5`, set to `no` for unlimited)
* `TM_JSHINTMATE_COMMAND` - the JSHint command to run (e.g. `/path/to/custom/jshint {FILE} --config {CONFIG} --reporter {REPORTER}`)
* `TM_JSHINTMATE_REPORTER` - the path to a custom reporter file
* `TM_JSHINTMATE_CONFIG` - the path to a custom JSHint config file
  * by default it will walk up the project tree to find the nearest `.jshintrc`, then looks for `~/.jshintrc`
* `TM_JSHINTMATE_WARN` - whether or not to show warnings (default: `false`)
* `TM_JSHINTMATE_WARN_UNUSED` - whether or not to show `unused variable` warnings (default: `$TM_JSHINTMATE_WARN`)
* `TM_JSHINTMATE_WARN_GLOBALS` - whether or not to list global variables (default: `$TM_JSHINTMATE_WARN`)
* `TM_JSHINTMATE_RAW` - if set to `true`, will display the raw JSON output (default: `false`)

## Lots of inspiration
... and borrowed code :)

* https://github.com/uipoet/sublime-jshint
* https://github.com/fgnass/jshint.tmbundle
* https://github.com/rondevera/jslintmate
