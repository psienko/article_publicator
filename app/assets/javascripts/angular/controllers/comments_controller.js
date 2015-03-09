app.controller('CommentController', ['$scope', 'Comment', function($scope, Comment) {

  var id = window.Id;
  Comment.query({}, {articleId: id}).then( function(results){
    $scope.comments = results;
  });

  $scope.createComment = function() {
    new Comment({body: $scope.comment.body, articleId: id}).create().then(
      function (results) {
      $scope.comments.unshift(results);
      $scope.commentUpdated = true;
      $scope.errors = null;
      $scope.comment.body = "";
    },
    function (error) {
      $scope.commentUpdated = false;
      $scope.errors = error.data;
    })
  };
}]);
