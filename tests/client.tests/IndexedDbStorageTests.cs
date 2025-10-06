using Microsoft.JSInterop;
using Spot.Web.Services;

namespace Spot.Client.Tests;

public sealed class IndexedDbStorageTests
{
    [Fact]
    public async Task Should_import_module_once()
    {
        var jsRuntime = new FakeJsRuntime();
        var storage = new IndexedDbStorage(jsRuntime);

        await storage.EnqueueAsync("requests", new { id = 1 });
        await storage.DequeueAsync<object>("requests");

        Assert.Equal(1, jsRuntime.ImportInvocationCount);
    }

    private sealed class FakeJsRuntime : IJSRuntime
    {
        private readonly Lazy<IJSObjectReference> _module = new(() => new FakeJsObject());

        public int ImportInvocationCount { get; private set; }

        public ValueTask<TValue> InvokeAsync<TValue>(string identifier, object?[]? args)
        {
            if (identifier == "import")
            {
                ImportInvocationCount++;
                return ValueTask.FromResult((TValue)(object)_module.Value);
            }

            throw new NotImplementedException();
        }

        public ValueTask<TValue> InvokeAsync<TValue>(string identifier, CancellationToken cancellationToken, object?[]? args)
            => InvokeAsync<TValue>(identifier, args);

        private sealed class FakeJsObject : IJSObjectReference
        {
            public ValueTask DisposeAsync() => ValueTask.CompletedTask;

            public ValueTask<TValue> InvokeAsync<TValue>(string identifier, object?[]? args)
            {
                return ValueTask.FromResult(default(TValue)!);
            }

            public ValueTask<TValue> InvokeAsync<TValue>(string identifier, CancellationToken cancellationToken, object?[]? args)
                => InvokeAsync<TValue>(identifier, args);
        }
    }
}
