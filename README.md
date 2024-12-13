## Cuisinary
Recipe Searching Application built with SwiftUI

<img src="https://github.com/user-attachments/assets/c43acf33-3d41-4b1e-9942-0a0919896751" width="250" /> 

### Steps to Run the App
- Clone the repository
```
git clone https://github.com/MyatThuKo/Cuisinary.git
```
- Navigate to the downloaded project folder and open `Cuisinary.xcodeproj` file
- Install Package Dependencies (if required)
- Press `cmd+r` to build and run the app on a selected simulator

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
- MVVM Architecture for SwiftUI framework
  - This architecture allows me to do testing on view model and create mock models easier
- Dependency Injection for easier testing purposes
- Singleton pattern
  - Separating out the components views into each own file
  - Separating out the networking pieces into `Service` file from the view model
  - Break down large pieces of views into its own variable for better readibility

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
- Total time spent approximately 5 hours
  - Initial search & setup for images, assets and packages: 30 mins
  - MVVM architecture & UI Implementation: 1:30 hours
  - Research on Image Caching, NSCache & implementation: 1:30 hours
  - Unit tests: 1 hour
  - Optimization and Proof reading: 30 mins

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
- Dependency Injection
  - Decided to use dependency injection for better testing purposes
- SwiftUI over Programmatic UI
  - More comfortable for me to build this project in SwiftUI since I started the iOS development with SwiftUI
  - SwiftUI is more reactive and less time consuming to build

### Weakest Part of the Project: What do you think is the weakest part of your project?
- Image Caching
  - This topic is new to me although I learned a little bit from a Staff iOS engineer from my previous work.
  - Tried my best to understand the NSCache and Image Caching to the disk
- A bit weak on showcasing or handling the error case
  - Regardless of whether it's `empty-data` or `malformed-data`, I only show one error screen. (Not sure if it's enough to do only one error screen for both cases)

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
- Package Dependencies Used
  - YouTube iOS Player
- Added details view, search option, filter option and sort option to make it easier when looking for a recipe
  - Added a button to take to the original recipe page on details screen alongside with a embeded YouTube video player to avoid leaving the app when wanted to watch the video
 
<details>
  <summary> Screenshots and Video Walkthrough </summary>
  
  - Success Networking

  | Light | Dark | 
  |:--:|:--:|
  | ![success-light](https://github.com/user-attachments/assets/cfc0c15e-bcf2-4e8f-9e80-93c4727af6a7) | ![success-dark](https://github.com/user-attachments/assets/d90d8755-5873-445e-9b16-6a78b17039cb) |

  - Details View

  | Light | Dark |
  |:--:|:--:|
  |![details-light](https://github.com/user-attachments/assets/0513b7e0-85dd-4117-b42c-a9769aabe597)|![details-dark](https://github.com/user-attachments/assets/87759eaf-81b4-4670-9791-d24ec0eda7cf)|

  - Error Case

  | Light | Dark |
  |:--:|:--:|
  |![error-dark](https://github.com/user-attachments/assets/8940603f-5d03-4dea-b412-442608dccc56)|![error-light](https://github.com/user-attachments/assets/76579c76-6bd2-4930-96f8-6bdcca6d73dd)|

  - Videos

  | Details (YouTube Video) | Error Case | Success Case |
  |:--:|:--:|:--:|
  | <video src="https://github.com/user-attachments/assets/06b01e29-0ccc-4c84-a316-e22a8e1fc5cb" width="250" /> | <video src="https://github.com/user-attachments/assets/e58c3626-0bb5-4223-be77-ea5f2b92e3fd" width="250" /> | <video src="https://github.com/user-attachments/assets/2369d079-e1b8-42b6-a753-c49c5df24da7" width="250" /> | 

</details>
