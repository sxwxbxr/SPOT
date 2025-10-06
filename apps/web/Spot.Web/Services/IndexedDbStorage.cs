using Microsoft.JSInterop;

namespace Spot.Web.Services;

public sealed class IndexedDbStorage
{
    private readonly Lazy<Task<IJSObjectReference>> _moduleTask;

    public IndexedDbStorage(IJSRuntime jsRuntime)
    {
        _moduleTask = new Lazy<Task<IJSObjectReference>>(() =>
            jsRuntime.InvokeAsync<IJSObjectReference>("import", "./js/indexedDb.js").AsTask());
    }

    public async Task EnqueueAsync(string storeName, object payload, CancellationToken cancellationToken = default)
    {
        var module = await _moduleTask.Value.ConfigureAwait(false);
        await module.InvokeVoidAsync("enqueue", cancellationToken, storeName, payload);
    }

    public async Task<T?> DequeueAsync<T>(string storeName, CancellationToken cancellationToken = default)
    {
        var module = await _moduleTask.Value.ConfigureAwait(false);
        return await module.InvokeAsync<T?>("dequeue", cancellationToken, storeName);
    }
}
