(function() {
  'use strict';

  var env = process.env || process.ENV || {};
  var buffer = '';
  var true_rx = /^(?:true|yes|1)$/i;

  function numberWang(wangaNumb) {
    var
      thatsNumberWang = 8 - wangaNumb,
      stayNumberWang = '', i;
    for (i = 0; i < thatsNumberWang; i += 1) {
      stayNumberWang += ' ';
    }
    return ' ' + stayNumberWang;
  }

  function log(){
    var args = Array.prototype.slice.call(arguments);
    buffer += args.join('');
    buffer += '\n';
  }

  function stdout() {
    process.stdout.write(buffer);
  }

  function getErrors(errors) {
    return errors;
  }

  function getUnused(results) {
    // by default we'll hide unused var warnings (in detailed view),
    // you can turn this off by setting TM_JSHINTMATE_WARN_UNUSED = true in your .tm_properties
    if(!true_rx.test(env.TM_JSHINTMATE_WARN_UNUSED)) {
      return [];
    }
    var unused = [];
    // add on all unused var warnings
    results.forEach(function (result) {
      unused = unused.concat(result.unused || []);
    });
    return unused;
  }

  function getGlobals(results) {
    // by default we'll hide the list of global vars (in detailed view),
    // you can turn this off by setting TM_JSHINTMATE_WARN_GLOBALS = true in your .tm_properties
    if(!true_rx.test(env.TM_JSHINTMATE_WARN_GLOBALS)) {
      return [];
    }
    var globals = [];
    // add on all unused var warnings
    results.forEach(function (result) {
      globals = globals.concat(result.globals || []);
    });
    return globals;
  }

  // expose the interface
  module.exports = {
    numberWang: numberWang,
    log:        log,
    stdout:     stdout,
    getErrors:  getErrors,
    getUnused:  getUnused,
    getGlobals: getGlobals
  };
})();
