(function() {
  'use strict';

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
          unused = parser.getUnused(results);

      function log(items) {
        items.forEach(function (result, i) {
          var isError = !!result.error;
          var item = isError ? result.error : result;
          if(item && typeof item !== 'string') {
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
              message += item.name + ' is an unused variable.';
            }
            message += '</a>';
            parser.log(message);
          }
        });
      }

      if(errors.length || unused.length) {
        // output errors
        if(errors.length) {
          log(parser.getErrors(errors));
        }
        // output unused var warnings
        if(unused.length) {
          log(unused, true);
        }
      }
      else {
        parser.log('<p class="success">Lint Free!</p>');
      }

      // output whatever is on the buffer
      parser.stdout();
    }
  };
})();
