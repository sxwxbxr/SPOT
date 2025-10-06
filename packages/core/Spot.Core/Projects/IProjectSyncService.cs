namespace Spot.Core.Projects;

public interface IProjectSyncService
{
    Task EnqueueAsync(ProjectSummary project, CancellationToken cancellationToken = default);
}
