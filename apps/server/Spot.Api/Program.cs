using Microsoft.OpenApi.Models;
using Spot.Api.Options;

const string CorsPolicyName = "Default";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOptions<ConnectionStringsOptions>()
    .Bind(builder.Configuration.GetSection("ConnectionStrings"))
    .ValidateDataAnnotations()
    .ValidateOnStart();

builder.Services.AddOptions<OpenSearchOptions>()
    .Bind(builder.Configuration.GetSection("OpenSearch"))
    .ValidateDataAnnotations()
    .ValidateOnStart();

var configuredOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? Array.Empty<string>();

builder.Services.AddCors(options =>
{
    options.AddPolicy(CorsPolicyName, policy =>
    {
        var origins = configuredOrigins.Length > 0
            ? configuredOrigins
            : new[]
            {
                "http://localhost:5173",
                "https://localhost:5173",
                "http://localhost:5000",
                "https://localhost:5001"
            };

        policy.WithOrigins(origins)
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

builder.Services.AddHealthChecks();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "SPOT API",
        Version = "v1",
        Description = "Foundational API surface for the SPOT platform."
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors(CorsPolicyName);
app.MapHealthChecks("/healthz").WithName("HealthChecks");

app.MapGet("/", () => Results.Redirect("/swagger", permanent: false))
    .ExcludeFromDescription();

app.MapGet("/api/status", () => Results.Ok(new
    {
        name = "spot-api",
        version = typeof(Program).Assembly.GetName().Version?.ToString() ?? "0.0.0",
        timestamp = DateTimeOffset.UtcNow
    }))
    .WithName("GetStatus")
    .WithOpenApi();

app.Run();

public partial class Program;
