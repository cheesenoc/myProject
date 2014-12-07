angular
  .module('example')
  .controller 'LearnMoreController', ($scope, supersonic) ->

    $scope.navbarTitle = "Learn More"

    # all the below examples assume that variable Beer has been created
    Beer = supersonic.data.model('beer')

    $scope.getBeer = () ->
      Beer.findAll().then (allBeers) ->
        console.log "the first was #{allBeers[0].name}"
        $scope.beer1 = allBeers[0]

        for beer in allBeers
          console.log "#{beer.name} by #{beer.brewery} brewed since #{beer.brewed_since}"
