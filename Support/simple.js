(function() {
  'use strict';

  module.exports = {
    reporter: function (errors) {
      var parser = require('./parser');

      if (errors && errors.length) {
        parser.log('JSHint preview');
        errors = parser.getErrors(errors, 5);
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
