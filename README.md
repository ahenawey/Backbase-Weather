# Weather
## Architecture
MVP
![MVP](https://cdn-images-1.medium.com/max/1400/1*hKUCPEHg6TDz6gtOlnFYwQ.png)
The MVP is the first pattern that reveals the assembly problem which happens due to having three actually separate layers. Since we don’t want the View to know about the Model, it is not right to perform assembly in presenting view controller (which is the View), thus we have to do it somewhere else. For example, we can make the app-wide Router service which will be responsible for performing assembly and the View-to-View presentation. This issue arises and has to be addressed not only in the MVP but also in all the following patterns.
</br>
Presenter, has nothing to do with the life cycle of the view controller, and the View can be mocked easily, so there is no layout code in the Presenter at all, but it is responsible for updating the View with data and state.
## Error Handling
### Asynchronous error handling for Workers (Result pattern)
```swift
func fetch(coordinate: CLLocationCoordinate2D,
               useMeteric: Bool,
               completionHandler: @escaping (Result<WeatherDetails.Forecast, WeatherStoreError>) -> ()) {

        ...

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                completionHandler(.failure(.error(error)))
                return
            }

            guard let data = data,
                let storngSelf = self else {
                completionHandler(.failure(.cannotFetch("empty respose")))
                return
            }

            do{
                let forecast = try storngSelf.parse(data)
                completionHandler(.success(forecast))
            }catch (let error) {
                completionHandler(.failure(.error(error)))
            }
        }.resume()
    }

    func getWeatherForcast(for coordinate: CLLocationCoordinate2D,useMeteric: Bool, completionHandler: @escaping (Result<WeatherDetails.Forecast, WeatherStoreError>) -> ()) {
      fetch(coordinate: coordinate, useMeteric: useMeteric, completionHandler: completionHandler)
    }
```

We have a enum with 2 cases, one for success with associated type, and one for failure with associated error type

And can be used as following
```swift
func loadForecast(selectedCity: City)
{
    service.getWeatherForcast(for: selectedCity.coordinates, useMeteric: Locale.current.usesMetricSystem, completionHandler: { [weak self] (result) in
        DispatchQueue.main.async {
            switch result {
                case .success(let forecast):
                    self?.viewController?.displayWeatherForecast(forecast: forecast)
                case .failure(let error):
                    self?.viewController?.displayError(error: error)
            }           
        }
    })
}
```
Using a switch statement allows powerful pattern matching, and ensures all possible results are covered

## Development and architecture
Why MVP for small task?
1. Balanced distribution of responsibilities among entities with strict roles.
1. Testability usually comes from the first feature
1. Ease of use and a low maintenance cost.

## Release notes
1. Unit Tests for Home scene with coverage 19.21% of the whole application.
2. The Mobile API layer could be more abstracted by making another layer for Networking layer to be more testable.
3. It's need more time to add the bouns points which the need some updates in Mobile API layer and UI Screen.
