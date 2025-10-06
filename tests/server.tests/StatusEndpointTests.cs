using System.Net.Http.Json;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Spot.Core.Status;

namespace Spot.Server.Tests;

public sealed class StatusEndpointTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public StatusEndpointTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory.WithWebHostBuilder(_ => { });
    }

    [Fact]
    public async Task Should_return_api_status_payload()
    {
        using var client = _factory.CreateClient();
        var response = await client.GetAsync("/api/status");

        response.IsSuccessStatusCode.Should().BeTrue();

        var payload = await response.Content.ReadFromJsonAsync<ApiStatusDto>();
        payload.Should().NotBeNull();
        payload!.Name.Should().Be("spot-api");
    }
}
