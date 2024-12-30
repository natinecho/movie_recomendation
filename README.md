# Movie Recommendation App

A mobile application that provides personalized movie recommendations using The Movie Database (TMDB) API. Built with Flutter and Firebase, the app offers a visually appealing and user-friendly interface for exploring, searching, and managing movie preferences.

## Features

- **Landing Page**: 
  - An engaging introduction with a movie image background and navigation to login or sign-up.

- **User Authentication**: 
  - Secure login and registration system using Firebase Authentication.

- **Home Page**:
  - Displays categorized lists of movies such as "Most Viewed", "Popular", and "Recent Releases" with horizontal scrolling.

- **Movies Page**:
  - Allows users to explore all movies with filtering and search capabilities.

- **Movie Detail Page**:
  - Provides detailed information about selected movies, including related movie suggestions.

- **User Profile Page**:
  - Displays user information and enables logout functionality.

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Firebase
  - Authentication
  - Firestore Database
  - Cloud Storage
- **API**: TMDB (The Movie Database)

## Installation

### Prerequisites
- Flutter SDK: [Install Flutter](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code with Flutter and Dart plugins installed
- A valid TMDB API key: [Get API Key](https://developers.themoviedb.org/3/getting-started/introduction)
- Firebase project set up for Android

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/natinecho/movie_recomendation.git
   cd movie-recommendation-app
2 Install dependencies:
  ```bash
  flutter pub get
  ```
  
3 Configure Firebase:

  Add your google-services.json file to the android/app/ directory.
  Set up Firebase Authentication and Firestore Database in your Firebase Console.
  
  Add your TMDB API key:
  Locate the file where API keys are stored, such as tmdb_service.dart.
  Add your API key:
  const String TMDB_API_KEY = 'YOUR_TMDB_API_KEY';

4 Run the app:
  ```bash
  flutter run
  ```

## Screenshots

![photo_2024-12-30_11-47-24](https://github.com/user-attachments/assets/69de90c0-201e-414a-8373-fec082bc08bc)  
![photo_2024-12-30_11-47-30](https://github.com/user-attachments/assets/abf04e45-7f16-4474-a506-98476ef552c3)   ![photo_2024-12-30_11-47-28](https://github.com/user-attachments/assets/8aae771e-2079-4bca-bdd3-b40f16cf564a)
![photo_2024-12-30_11-47-36](https://github.com/user-attachments/assets/e63cac97-0dec-4f58-8968-060018f2506d)   ![photo_2024-12-30_11-47-34](https://github.com/user-attachments/assets/b936ac7a-c534-488f-8702-879a1b1b1e0d)
