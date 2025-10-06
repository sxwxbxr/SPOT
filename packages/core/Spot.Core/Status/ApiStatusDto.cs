namespace Spot.Core.Status;

public sealed record ApiStatusDto(string Name, string Version, DateTimeOffset Timestamp);
