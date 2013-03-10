(function() {
  'use strict';

  var env = process.env || process.ENV || {};
  var true_rx = /^(?:true|yes|1)$/i;

  function html(s) {
    var entities = {
      '&': '&amp;',
      '"': '&quot;',
      '<': '&lt;',
      '>': '&gt;'
    };
    return (s || '').replace(/[&"<>]/g, function(c) {return entities[c] || c;});
  }

  module.exports = {
    reporter: function (errors, results) {
      var parser = require('./parser'),
          file = results[0].file,
          unused = parser.getUnused(results),
          globals = parser.getGlobals(results);

      function log(items, type) {
        items.forEach(function (result, i) {
          var isError = !!result.error;
          var item = isError ? result.error : result;
          var appendage = {
            unused:   ' is an unused variable.',
            globals:  ' is an implied global variable.',
            unknown:  ' raised an unknown warning.'
          };
          appendage = appendage[type] || appendage.unknown;
          if(item && (typeof item !== 'string' || type === 'globals')) {
            var link = 'txmt://open?url=file://' + encodeURI(file) + '&line=' + item.line + '&column=' + item.character;
            var message = ('<a class="txmt" href="' + link + '" id="' + (isError ? 'e' : 'w') + (i+1) + '">');
            if(isError) {
              if (i < 9) {
                message += '<b>'+(i+1)+'</b>';
              }
              message += item.reason;
              if (item.evidence && !isNaN(item.character)) {
                message += '<tt>';
                message += html(item.evidence.substring(0, item.character-1));
                message += '<em>';
                message += (item.character <= item.evidence.length) ? html(item.evidence.substring(item.character-1, item.character)) : '&nbsp;';
                message += '</em>';
                message += html(item.evidence.substring(item.character));
                message += '</tt>';
              }
            }
            else {
              message += (item.name || item) + appendage;
            }
            message += '</a>';
            parser.log(message);
          }
        });
      }
      if(errors.length || unused.length || globals.length) {
        // output errors
        if(errors.length) {
          log(parser.getErrors(errors));
        }
        // output unused var warnings
        if(unused.length) {
          log(unused, 'unused');
        }
        // output list of globals
        if(globals.length) {
          log(globals, 'globals');
        }
      }
      else {
        parser.log('<p class="success">Lint Free!</p>');
      }

      // output the raw JSON if needed
      if(true_rx.test(env.TM_JSHINTMATE_RAW)) {
        parser.log('<h2>Raw Ouput from JSHint:</h2>');
        parser.log('<pre>' + JSON.stringify(results, null, '  ') + '</pre>');
      }

      // output whatever is on the buffer
      parser.stdout();
    }
  };
})();
