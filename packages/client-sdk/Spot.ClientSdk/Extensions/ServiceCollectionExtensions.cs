using Microsoft.Extensions.DependencyInjection;
using Refit;
using Spot.ClientSdk.Abstractions;

namespace Spot.ClientSdk.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddSpotApiClient(this IServiceCollection services, Action<HttpClient>? configureClient = null)
    {
        ArgumentNullException.ThrowIfNull(services);

        services
            .AddRefitClient<ISpotApi>(new RefitSettings
            {
                ContentSerializer = new SystemTextJsonContentSerializer()
            })
            .ConfigureHttpClient((_, client) =>
            {
                client.BaseAddress ??= new Uri("http://localhost:5187");
                configureClient?.Invoke(client);
            });

        return services;
    }
}
