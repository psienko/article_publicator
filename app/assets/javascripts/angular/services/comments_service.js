app.factory('Comment', ['railsResourceFactory', function (railsResourceFactory) {
  return railsResourceFactory({url: '4/comments/{{id}}', name: 'comment'});
}]);
