samson.factory('SseFactory', function() {
  'use strict';

  var sse = {
    connection: null,

    init: function() {
      this.connection = new EventSource(window.location.origin + '/stream' + '/streaming');
    },

    on: function(event, callback) {
      this.connection.addEventListener(event, function(e) {
        callback(JSON.parse(e.data));
      });
    }
  };

  sse.init();
  return sse;
});
