# Fasahny (فسحني)

Fasahny is a travel and tourism platform built for exploring, planning, and booking trips across Egypt. It combines AI-assisted itinerary planning with hotel, restaurant, and transport booking, alongside a community feed where travelers share real trip experiences.

## Overview

Fasahny is designed around a simple idea: planning a trip in Egypt should be as easy as browsing a feed. The platform offers two planning paths — a fully automated AI itinerary builder, and a manual booking flow for travelers who prefer full control — alongside dedicated destination guides, hotel and restaurant discovery, and transport booking, all in one place.

## Features

**AI Trip Planner**
A three-step planning flow — destination and duration, preferences, and review — that generates a complete day-by-day itinerary with timed activities, pricing, and suggested accommodation. Individual activities can be edited, and the plan can be regenerated at any point with a live budget breakdown.

**Manual Trip Booking**
A more direct booking flow for travelers who want to select their own hotel, transport, and activities, with pricing that updates in real time.

**Destination Guides**
Dedicated pages for major Egyptian destinations — including Luxor, Aswan, Hurghada, Dahab, and Sharm El Sheikh — featuring current weather, top-rated accommodation, key landmarks and activities, and photos shared by the community.

**Hotels**
Detailed listing pages with photo galleries, amenities, room types, guest reviews, and an integrated booking flow.

**Restaurants**
A searchable directory of restaurants filterable by cuisine, price range, and ambiance, with ratings and photos.

**Transport**
A single hub for booking internal flights, renting a car, or reserving a Nile cruise, with search and filtering.

**Community**
A social feed where travelers post real trip moments and itineraries, which others can browse and use as the basis for their own trips.

**Accounts**
Login, registration, trip history, and a personal dashboard for managing bookings and saved trips.

## Tech Stack

- Vue 3 (Composition API, `<script setup>`)
- Vite
- Vue Router
- Tailwind CSS

## Project Structure
src/
├── components/ Reusable UI components (Navbar, HotelCard, TripCard, RestaurantCard)
├── pages/ Route-level views (Home, CityDetail, HotelDetail, AiTripPlanner)
├── router/ Vue Router configuration
├── App.vue
├── main.js
└── style.css
## Getting Started

```bash
# Install dependencies
npm install

# Start the development server
npm run dev

# Build for production
npm run build
```

## Team

Developed as part of the DEPI program.

---

© 2026 Fasahny. All rights reserved.