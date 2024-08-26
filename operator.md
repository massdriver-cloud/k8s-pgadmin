## PostgreSQL on Kubernetes (k8s-pgadmin)

PostgreSQL is a powerful, open-source object-relational database system that uses and extends the SQL language. It is designed to handle various tasks, from small applications to large-scale web services. Managing PostgreSQL in a Kubernetes environment allows you to leverage container orchestration to ensure your database is highly available and scalable.

### Design Decisions

- **Helm Charts**: We use Helm charts for deploying PostgreSQL and PgAdmin within the Kubernetes cluster. This approach simplifies the deployment and management of these services.
- **Persistent Volumes**: We use Persistent Volumes for data storage to ensure data persistence and resilience.
- **Service Mesh**: Integration with service mesh for secure and reliable service-to-service communication.
- **Resource Management**: Pod resource requests and limits are configured to ensure optimal performance and reliability.
- **Secret Management**: Database credentials and other sensitive information are managed using Kubernetes secrets.

### Runbook

#### Issues Accessing PgAdmin Interface

If you are unable to access the PgAdmin interface:

- Make sure the PgAdmin pod is running:
    ```sh
    kubectl get pods -l app=pgadmin
    ```
    You should see the PgAdmin pod with a `Running` status.

- Check the service to confirm it's exposing the correct port:
    ```sh
    kubectl get svc pgadmin-service
    ```
    Ensure the service is exposing the correct port, typically `80` or `443` for HTTP/HTTPS.

- Port-forward to access PgAdmin locally:
    ```sh
    kubectl port-forward svc/pgadmin-service 8080:80
    ```
    Access PgAdmin via your web browser at `http://localhost:8080`.

#### PostgreSQL Connection Issues

If your application cannot connect to the PostgreSQL database:

- Ensure the PostgreSQL pod is running:
    ```sh
    kubectl get pods -l app=postgres
    ```
    Confirm the PostgreSQL pod is in a `Running` state.

- Check the service to ensure it's correctly exposing the PostgreSQL port (default `5432`):
    ```sh
    kubectl get svc postgres-service
    ```
    Verify the service is exposing port `5432`.

- Test the PostgreSQL connection from within the cluster:
    ```sh
    kubectl run -it --rm --image=postgres --env="PGPASSWORD=<password>" pgsql-client -- psql -h postgres-service -U <username> -d <database>
    ```
    Replace `<password>`, `<username>`, and `<database>` with your PostgreSQL credentials. This command should log you into the PostgreSQL database.

#### Data Persistence Issues

If your PostgreSQL data is not persisting across pod restarts:

- Check the Persistent Volume Claims (PVC) status:
    ```sh
    kubectl get pvc -l app=postgres
    ```
    Ensure the PVCs are in `Bound` status indicating they're correctly attached to Persistent Volumes (PVs).

- Describe the PVC for more details:
    ```sh
    kubectl describe pvc <pvc-name>
    ```
    Look for any warnings or events indicating issues with the Persistent Volume.

- Verify the Persistent Volume status:
    ```sh
    kubectl get pv
    ```
    Ensure the PV is available and correctly bound to the PVC.

#### High Memory or CPU Usage

If you notice high memory or CPU usage affecting PostgreSQL performance:

- Check resource usage of the PostgreSQL pod:
    ```sh
    kubectl top pod -l app=postgres
    ```
    Look for high memory or CPU usage.

- Describe the pod to check for OOMKill or other resource-related events:
    ```sh
    kubectl describe pod <pod-name>
    ```
    Look for any events indicating the pod was OOMKilled or throttled.

- Update resource requests and limits as needed:
    Edit your deployment or stateful set configuration to adjust resource requests and limits:
    ```yaml
    resources:
      requests:
        memory: "2Gi"
        cpu: "1000m"
      limits:
        memory: "4Gi"
        cpu: "2000m"
    ```

#### PostgreSQL Error Logs

If PostgreSQL is not performing as expected:

- Access PostgreSQL logs:
    ```sh
    kubectl logs <postgres-pod-name>
    ```
    Look for any error messages indicating issues with PostgreSQL operations.

- Connect directly to the PostgreSQL pod and check logs:
    ```sh
    kubectl exec -it <postgres-pod-name> -- bash
    tail -f /var/log/postgresql/postgresql.log
    ```

By leveraging Kubernetes for managing PostgreSQL and PgAdmin, you improve the scalability, reliability, and management of your SQL databases in a cloud-native environment. Ensure you follow best practices for resource management, secret management, and persistent storage to maintain high availability and efficiency.

