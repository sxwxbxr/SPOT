# SPOT Feature-Übersicht

## ✅ Implementierte Features

- **Blazor WebAssembly Dashboard mit Offline-Hinweisen und 3D-Vorschau** – Die Startseite präsentiert den Offline-First-Nutzen, rendert Spot-Badges aus der UI-Bibliothek und lädt ein glTF-Modell über Three.js in einem Canvas. 【F:apps/web/Spot.Web/Pages/Home.razor†L1-L46】
- **IndexedDB-gestützter Offline-Puffer für Client-Anfragen** – Ein C#-Service kapselt die JavaScript-Interop, um Payloads in einer lokalen Warteschlange zu speichern und wieder abzurufen. 【F:apps/web/Spot.Web/Services/IndexedDbStorage.cs†L1-L26】【F:apps/web/Spot.Web/wwwroot/js/indexedDb.js†L1-L50】
- **Three.js-Integration für WebGL-Rendering** – Ein dediziertes JS-Modul und die zugehörige .NET-Interop abstrahieren das Laden und Anzeigen von glTF-Szenen. 【F:apps/web/Spot.Web/Interop/ThreeJs/ThreeJsModule.cs†L1-L31】【F:apps/web/Spot.Web/wwwroot/js/threeInterop.js†L1-L31】
- **ASP.NET Core API-Grundgerüst** – Der Server stellt konfigurierte CORS-Richtlinien, Health Checks, Swagger UI sowie einen Status-Endpunkt bereit und validiert Verbindungs- und OpenSearch-Optionen. 【F:apps/server/Spot.Api/Program.cs†L1-L77】【F:apps/server/Spot.Api/Options/ConnectionStringsOptions.cs†L1-L9】【F:apps/server/Spot.Api/Options/OpenSearchOptions.cs†L1-L16】
- **Typed Client SDK auf Basis von Refit** – Erweiterungsmethoden registrieren einen typisierten `ISpotApi`-Client, der das Status-DTO aus dem gemeinsamen Kern nutzt. 【F:packages/client-sdk/Spot.ClientSdk/Extensions/ServiceCollectionExtensions.cs†L1-L26】【F:packages/client-sdk/Spot.ClientSdk/Abstractions/ISpotApi.cs†L1-L10】【F:packages/core/Spot.Core/Status/ApiStatusDto.cs†L1-L3】
- **Geteilte UI- und Domänen-Bausteine** – Das UI-Paket liefert wiederverwendbare Komponenten wie `SpotBadge`, während der Core-Kontext Project-Sync-Verträge und DTOs definiert. 【F:packages/ui/Spot.UI/Components/SpotBadge.razor†L1-L9】【F:packages/core/Spot.Core/Projects/ProjectSummary.cs†L1-L3】【F:packages/core/Spot.Core/Projects/IProjectSyncService.cs†L1-L6】

## 🚧 Geplante Features

- **EF Core DbContext und Seed-Migrationen** zur Persistenz von Projektdaten. 【F:README.md†L287-L292】
- **OpenSearch-Integration sowie Microsoft Graph/FileCloud Adapter** für erweiterte Suche und Dokumentensynchronisation. 【F:README.md†L289-L292】
- **Ausgereiftere Offline-Synchronisation inklusive erweiterter IndexedDB-Schemata und Sync-Orchestrierung**. 【F:README.md†L291-L306】
- **Produktionsreife Bereitstellung mit gehärteten Dockerfiles und Deployment-Playbooks**. 【F:README.md†L307-L309】
