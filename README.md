# NetworkKit

iOS app's connectivity with NetworkKit – a simple yet powerful network layer seamlessly integrating Combine Framework, Async/Await, and Unit Tests.

# GitHub Repos 

Checkout this sample project [SwiftMVVMDemo](https://github.com/rushisangani/SwiftMVVMDemo).

## Examples

```swift
public protocol NetworkHandler {
    func fetch<T: Decodable>(request: Request) async throws -> T
    func fetch<T: Decodable>(request: Request) -> AnyPublisher<T, RequestError>
}
```

```swift
import NetworkKit

class PostService: PostRetrievalService {
    let networkManager: NetworkHandler
    
    init(networkManager: NetworkHandler = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPosts() async throws -> [Post] {
        try await networkManager.fetch(request: PostRequest.getPosts)
    }
}
```

### Installation

Add `NetworkKit` to your project using Swift Package Manager - https://github.com/rushisangani/NetworkKit

## Contributions

 Feel free to submit issues or pull requests to enhance the functionality of NetworkKit.

## Connect with Me

Connect with me on [LinkedIn](https://www.linkedin.com/in/rushisangani/) or follow me on [Medium](https://medium.com/@rushisangani).
