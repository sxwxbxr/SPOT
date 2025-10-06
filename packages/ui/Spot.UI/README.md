# Spot.UI

Shared Razor component library for SPOT applications. Components are designed to be portable across Blazor WebAssembly, Server, and future .NET MAUI or Electron shells.

## Usage

```csharp
builder.Services.AddRazorComponents();
```

In your Razor file:

```razor
<SpotBadge Label="Offline" />
```

Styles are shipped via `wwwroot/css/spot-ui.css`. Consume them by adding the stylesheet reference to your host page.
