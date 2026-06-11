{
    "api": {
        "hostname": "\(.outputs[] | select(.kind == "Service" and .apiVersion == "v1") | .metadata.name).\(.params.provisioner.namespace).svc.cluster.local",
        "port": (.outputs[] | select(.kind == "Service" and .apiVersion == "v1") | .spec.ports[] | select(.name == "http") | .port),
        "protocol": "http"
    },
    "specs": {
        "api": {
            "version": "N/A"
        }
    }
}
