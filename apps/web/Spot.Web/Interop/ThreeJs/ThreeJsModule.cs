using Microsoft.JSInterop;

namespace Spot.Web.Interop.ThreeJs;

public sealed class ThreeJsModule : IAsyncDisposable
{
    private readonly Lazy<Task<IJSObjectReference>> _moduleTask;

    public ThreeJsModule(IJSRuntime jsRuntime)
    {
        _moduleTask = new Lazy<Task<IJSObjectReference>>(() =>
            jsRuntime.InvokeAsync<IJSObjectReference>("import", "./js/threeInterop.js").AsTask());
    }

    public async ValueTask RenderSceneAsync(string canvasId, string gltfUrl, CancellationToken cancellationToken = default)
    {
        var module = await _moduleTask.Value.ConfigureAwait(false);
        await module.InvokeVoidAsync("renderScene", cancellationToken, canvasId, gltfUrl);
    }

    public async ValueTask DisposeAsync()
    {
        if (!_moduleTask.IsValueCreated)
        {
            return;
        }

        var module = await _moduleTask.Value.ConfigureAwait(false);
        await module.DisposeAsync();
    }
}
