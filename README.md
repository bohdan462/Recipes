The app opens to a single SwiftUI screen that lists recipes from the provided JSON feed. Each row shows the dish’s small photo, name, and cuisine. A pull to refresh gesture reloads the feed. A toolbar menu lets you sort the list alphabetically or by cuisine, and a search bar filters the list as you type. When no recipes match the current search or the feed is empty, an in app empty state appears. Tapping buttons inside a row opens the recipe’s source page or YouTube video in a Safari sheet. Images load only when their rows appear, they are stored in RAM and on disk via a custom actor so scrolling stays smooth even after repeated runs.

Focus Areas
I concentrated on three things: clean async data flow, a hand rolled image cache that writes to disk, and a lightweight SwiftUI interface that reacts to state changes without boilerplate.

Time Spent
I worked on the project for about five hours in total. Roughly two hours went to building the basic list and network layer, one hour to writing and testing the image cache actor, another hour to adding search, sort, and empty state polish, and the final hour to writing unit tests and the README.

Trade‑offs and Decisions
I kept everything in one Xcode target to avoid unnecessary structure for a small demo. I chose not to cache the JSON itself because refetching a lightweight list felt cheaper and the spec only required efficient image handling. I targeted iOS 16.

Weakest Part of the Project
The disk cache evicts items purely by a count limit, not by access date or total byte size. A real app would benefit from an LRU policy and perhaps periodic pruning.

Additional Information
All core logic is covered by two XCTest cases: one checks that the image cache is thread‑safe under heavy concurrency, and another verifies that the view model sort and search work as intended. The project contains no third party code or URLCache usage every network request and disk write is managed directly with URLSession and FileManager.
