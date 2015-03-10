var app = angular.module("Article-publicator", ['rails']);

app.run(['$compile', '$rootScope', '$document', function($compile, $rootScope, $document) {
   return $document.on('page:load', function() {
      var body, compiled;
      body = angular.element('body');
      compiled = $compile(body.html())($rootScope);
      return body.html(compiled);
   });
}])


