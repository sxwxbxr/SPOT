using Microsoft.Playwright;

namespace Spot.E2E.Tests;

public sealed class SmokeTests
{
    [Fact]
    public async Task Home_page_should_render_title()
    {
        using var playwright = await Playwright.CreateAsync();
        await using var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = true
        });

        var baseAddress = Environment.GetEnvironmentVariable("SPOT_WEB_URL") ?? "http://localhost:5173";
        var page = await browser.NewPageAsync();

        await page.GotoAsync(baseAddress, new PageGotoOptions { WaitUntil = WaitUntilState.NetworkIdle });
        var heading = await page.TextContentAsync("h1");

        Assert.Contains("SPOT", heading, StringComparison.OrdinalIgnoreCase);
    }

    [Fact(Skip = "Install Playwright browsers and run against a live server before enabling.")]
    public Task Offline_manifest_should_be_accessible() => Task.CompletedTask;
}
