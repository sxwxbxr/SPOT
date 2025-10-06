using System.ComponentModel.DataAnnotations;

namespace Spot.Api.Options;

public sealed class ConnectionStringsOptions
{
    [Required]
    public required string Postgres { get; init; }
}
