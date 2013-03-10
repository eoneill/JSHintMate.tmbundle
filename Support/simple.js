(function() {
  'use strict';

  var env = process.env || process.ENV || {};

  module.exports = {
    reporter: function (errors) {
      var parser = require('./parser');

      function trimArray(array, max) {
        max = parseInt(max, 10);
        var total = array.length;
        if(max && total > max) {
          array = array.slice(0, max);
          array.push({error : '... and ' + (total - max) + ' more'});
        }
        return array;
      }

      if (errors && errors.length) {
        parser.log('JSHint preview');
        errors = trimArray(parser.getErrors(errors), env.TM_JSHINTMATE_PEVIEW_MAX);
        errors.forEach(function (result) {
          var error = result.error;
          if(typeof error === 'string') {
            parser.log(error);
          }
          else if(error) {
            parser.log(parser.numberWang((error.line.toString() + error.character.toString()).length), error.line + ',' + error.character + ': ', error.reason);
          }
        });
      }
      parser.stdout();
    }
  };
})();
