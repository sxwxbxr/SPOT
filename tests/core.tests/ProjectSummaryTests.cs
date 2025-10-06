using Spot.Core.Projects;

namespace Spot.Core.Tests;

public sealed class ProjectSummaryTests
{
    [Fact]
    public void Should_preserve_values_when_constructed()
    {
        var id = Guid.NewGuid();
        var summary = new ProjectSummary(id, "Flight Deck", DateTimeOffset.UtcNow);

        Assert.Equal(id, summary.Id);
        Assert.Equal("Flight Deck", summary.Name);
    }
}
