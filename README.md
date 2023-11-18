App Design Project
===

# Ecospotter

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [Sprint Plan](#Sprint-Plan)

## Overview

**Description:** Ecospotter is a mobile application designed to help users locate eco-friendly services, recycling centers, and sustainable lifestyle options nearby. It provides users with an easy way to contribute to and benefit from a greener planet by making eco-friendly choices accessible and community-driven.

**App Evaluation:**
- **Category:** Lifestyle / Environment
- **Mobile Features:** GPS, location tracking, real-time updates.
- **Story:** Ecospotter tells a story of individual contribution to environmental sustainability.
- **Market:** Eco-conscious individuals and anyone looking to make more sustainable lifestyle choices.
- **Habit:** Users are likely to use the app regularly for day-to-day sustainable choices.
- **Scope:** The initial version will focus on mapping places that need enviromental help, with potential to expand to social features and more interactive elements.

## User Stories

**Required Must-have Stories**
* Users can view a map with pins for nearby sites that need attention.
* Users can tap on a pin to view details about a selected site, including its name, description, images, and ratings.
* Users can get directions to an pin from their current location.
* Users can add new pins to the map, providing details such as name, description, images, and category.
* Users can review and rate pins, providing feedback and a rating from 1 to 5 stars.

**Optional Nice-to-have Stories**

* Users can log in and create a profile to track their contributions to environmental sustainability.
* Users can see their profile with details about their eco-footprint, contributions, and badges earned.
* Users can follow and connect with other eco-conscious users, forming a community.
* Users can share their eco-friendly activities and achievements on a social feed.
* Users can earn rewards or badges for frequent use and making sustainable choices.
* Users can participate in eco-challenges or activities suggested by the app.

## Screen Archetypes

**Map View Screen**
* Users can view a map with pins for nearby sites that need attention.

**Pin Details Screen**
* Users can view details about a pin, including name, description, images, ratings, and reviews.
* Users can get directions to the selected place from their current location.
* Users can read and submit reviews and ratings for the place.

**Add Place Screen**
* Users can add a new pins to the map, providing details like name, description, images, and category.
* Users can specify whether the incident is a Environmental Hazard, Deforestation, Litter Cleanup and etc.
* After submission, returns to the Map View Screen with the new pin added.

**Profile Screen**
* Users can view their profile with details about their eco-footprint, contributions, and badges earned.
* Users can view their badges and rewards earned.

## Navigation

**Tab Navigation** (Tab to Screen)

* Map View: Displays a map with eco-friendly pins.
* Add Pin: Allows users to add new eco-friendly places.
* Profile: Shows user's profile and achievements.

**Flow Navigation** (Screen to Screen)

**Map View Screen**
* Clicking on a pin goes to the Place Details Screen, displaying information about the selected place.
* Clicking on the "Add Place" button opens the Add Place Screen for users to submit a new eco-friendly place.

**Place Details Screen**
* Provides options to get directions to the place or read and submit reviews.
* The "Back" button returns to the Map View Screen.

**Add Place Screen**
* After submission, returns to the Map View Screen with the new pin added.

**Profile Screen**
* Users can navigate to Settings or Edit Profile.

## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

[This section will be completed in Unit 9]

### Models

[Add table of models]

### Networking

- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

## Sprint Plan

### Sprint 1: Project Setup and Basic Functionality (Week 1)

- [ ] Set up the project environment, including Xcode or your chosen development tool.
- [ ] Create the main user interface components, including the map view and basic UI elements.
- [ ] Ensure that the app can display pinned locations on the map with basic details.
- [ ] Set up tab bar so it navigates to each view controller
- [ ] Design and implement the Pin Details screen, where users can view detailed information about a selected pin.

### Sprint 2: Pin Details and User Interaction (Week 2)

- [ ] Implement the ability to get directions to a selected pin from the current location.
- [ ] Allow all users to see new eco-friendly places to the map with details and images.
- [ ] Focus on user interaction and ensure that the app is user-friendly.

### Sprint 3: User Profiles and Final Polish (Week 3)

- [ ] Develop user profiles where users can track their contributions, see their recent activities, and view earned badges.
- [ ] Polish the app's user interface, fix any bugs, and optimize performance.

