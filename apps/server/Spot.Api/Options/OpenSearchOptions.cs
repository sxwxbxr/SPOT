using System.ComponentModel.DataAnnotations;

namespace Spot.Api.Options;

public sealed class OpenSearchOptions
{
    [Required]
    [Url]
    public required string Uri { get; init; }

    public string? Username { get; init; }

    public string? Password { get; init; }

    public bool DisableSslVerification { get; init; }
}
