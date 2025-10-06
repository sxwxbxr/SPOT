namespace Spot.Core.Projects;

public sealed record ProjectSummary(Guid Id, string Name, DateTimeOffset UpdatedAtUtc);
