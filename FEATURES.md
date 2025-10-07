# SPOT Feature Overview · SPOT Funktionsübersicht

## 🇩🇪 Aktueller Stand

### ✅ Implementierte Funktionen

- **Blazor WebAssembly Dashboard mit Offline-Messaging und 3D-Vorschau** – Die Landingpage hebt SPOTs Offline-First-Versprechen hervor, rendert Spot-Badges aus der geteilten UI-Bibliothek und lädt ein glTF-Modell via Three.js. (apps/web/Spot.Web/Pages/Home.razor)
- **IndexedDB-gestützte Offline-Warteschlange für Client-Anfragen** – Ein C#-Dienst kapselt die JavaScript-Interop, speichert Payloads lokal und spielt sie nach Wiederherstellung der Verbindung ab. (apps/web/Spot.Web/Services/IndexedDbStorage.cs, apps/web/Spot.Web/wwwroot/js/indexedDb.js)
- **Three.js-Integration für WebGL-Rendering** – Ein dediziertes JavaScript-Modul und die .NET-Interop-Fläche kapseln das Laden und Darstellen von glTF-Szenen. (apps/web/Spot.Web/Interop/ThreeJs/ThreeJsModule.cs, apps/web/Spot.Web/wwwroot/js/threeInterop.js)
- **ASP.NET Core API-Grundlage** – Der Server konfiguriert CORS, Health Checks, Swagger UI und einen Status-Endpunkt und validiert Verbindungszeichenfolgen sowie OpenSearch-Optionen. (apps/server/Spot.Api/Program.cs, apps/server/Spot.Api/Options)
- **Typisierte Client-SDK auf Basis von Refit** – Erweiterungsmethoden registrieren einen stark typisierten `ISpotApi`-Client, der das gemeinsame Status-DTO aus dem Core-Paket konsumiert. (packages/client-sdk/Spot.ClientSdk, packages/core/Spot.Core/Status)
- **Geteilte UI- und Domain-Bausteine** – Das UI-Paket stellt wiederverwendbare Komponenten wie `SpotBadge` bereit, während der Core-Kontext Projekt-Sync-Verträge und DTOs exponiert. (packages/ui/Spot.UI/Components, packages/core/Spot.Core/Projects)

### 🚧 Geplante Funktionen

- **EF Core DbContext und Seed-Migrationen** zur Persistierung von Projektdaten. (siehe README.md Roadmap)
- **OpenSearch-Integration sowie Microsoft Graph/FileCloud-Adapter** für erweiterte Suche und Dokumentensynchronisierung. (siehe README.md Roadmap)
- **Erweiterte Offline-Synchronisierung** mit ausgereiften IndexedDB-Schemata und Orchestrierung. (siehe README.md Roadmap)
- **Produktionsreife Deployment-Artefakte** inklusive gehärteter Dockerfiles und operativer Playbooks. (siehe README.md Roadmap)

## 🇬🇧 Current Status

### ✅ Implemented Features

- **Blazor WebAssembly dashboard with offline messaging and 3D preview** – The landing page highlights SPOT's offline-first value proposition, renders Spot badges from the shared UI library, and loads a glTF model via Three.js. (apps/web/Spot.Web/Pages/Home.razor)
- **IndexedDB-backed offline queue for client requests** – A C# service wraps the JavaScript interop to persist payloads locally and replay them once connectivity is restored. (apps/web/Spot.Web/Services/IndexedDbStorage.cs, apps/web/Spot.Web/wwwroot/js/indexedDb.js)
- **Three.js integration for WebGL rendering** – A dedicated JavaScript module and the .NET interop surface encapsulate loading and displaying glTF scenes. (apps/web/Spot.Web/Interop/ThreeJs/ThreeJsModule.cs, apps/web/Spot.Web/wwwroot/js/threeInterop.js)
- **ASP.NET Core API foundation** – The server configures CORS, health checks, Swagger UI, and a status endpoint while validating connection-string and OpenSearch options. (apps/server/Spot.Api/Program.cs, apps/server/Spot.Api/Options)
- **Typed client SDK powered by Refit** – Extension methods register a strongly typed `ISpotApi` client that consumes the shared status DTO from the core package. (packages/client-sdk/Spot.ClientSdk, packages/core/Spot.Core/Status)
- **Shared UI and domain building blocks** – The UI package provides reusable components like `SpotBadge`, while the core context exposes project-sync contracts and DTOs. (packages/ui/Spot.UI/Components, packages/core/Spot.Core/Projects)

### 🚧 Planned Features

- **EF Core DbContext and seed migrations** to persist project data. (see README.md roadmap)
- **OpenSearch integration plus Microsoft Graph/FileCloud adapters** for richer search and document synchronization. (see README.md roadmap)
- **Expanded offline synchronization** with advanced IndexedDB schemas and orchestration. (see README.md roadmap)
- **Production-ready deployment assets** including hardened Dockerfiles and operational playbooks. (see README.md roadmap)
