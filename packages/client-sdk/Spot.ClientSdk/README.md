# Spot.ClientSdk

Typed HTTP client for the SPOT API powered by Refit.

## Registration

```csharp
services.AddSpotApiClient(client =>
{
    client.BaseAddress = new Uri("https://localhost:5187");
});
```

Consume via DI:

```csharp
public sealed class StatusProbe(ISpotApi api)
{
    public Task<ApiStatusDto> FetchAsync(CancellationToken token) => api.GetStatusAsync(token);
}
```
