using Refit;
using Spot.Core.Status;

namespace Spot.ClientSdk.Abstractions;

public interface ISpotApi
{
    [Get("/api/status")]
    Task<ApiStatusDto> GetStatusAsync(CancellationToken cancellationToken = default);
}
