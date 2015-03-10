app.factory('Comment', ['railsResourceFactory', function (railsResourceFactory) {
  return railsResourceFactory({url: '/articles/'+window.Id+'/comments', name: 'comment'});
}]);
