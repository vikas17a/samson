samson.controller('currentDeployBadgeCtrl', function($scope, $http, SseFactory) {
  'use strict';

  $scope.currentActiveDeploys = 0;

  SseFactory.on('deploys', function(msg) {
    if (msg.type === 'new') {
      $scope.currentActiveDeploys += 1;
    } else if (msg.type === 'finish') {
      $scope.currentActiveDeploys -= 1;
    }
    updateBadge();
  });

  function updateBadge() {
    _.defer(function() { $scope.$apply(); });
    if ($scope.currentActiveDeploys > 0) {
      $('#currentDeploysBadge').show();
    } else {
      $scope.currentActiveDeploys = 0;
      $('#currentDeploysBadge').hide();
    }
  }

  function init() {
    $http.get('/deploy_ui/deploys/active_count.json').success(function(result) {
      $scope.currentActiveDeploys = result.deploy_count;
      updateBadge();
    });
  }

  init();
});
