(function() {
  'use strict';

  var buffer = '';

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

  function trimArray(array, max) {
    var total = array.length;
    if(max && total > max) {
      array = array.slice(0, max);
      array.push({error : '... and ' + (total - max) + ' more'});
    }
    return array;
  }

  function getErrors(errors, max) {
    return trimArray(errors, max);
  }

  function getUnused(results, max) {
    var unused = [];
    // add on all unused var warnings
    results.forEach(function (result) {
      unused = unused.concat(result.unused || []);
    });
    return trimArray(unused, max);
  }

  // expose the interface
  module.exports = {
    numberWang: numberWang,
    log:        log,
    stdout:     stdout,
    getErrors:  getErrors,
    getUnused:  getUnused
  };
})();
