{
    "serverDefinitions": {
        "enabled": true,
        "resourceType": "Secret",

        "servers": {
            "primaryServer": {
                "Name": "Primary Server",
                "Group": "Servers",
                "Port": .database.data.authentication.port,
                "Username": .database.data.authentication.username,
                "Host": .database.data.authentication.hostname,
                "Password": .database.data.authentication.password,
                "SSLMode": "prefer",
                "MaintenanceDB": "postgres"
            }
        }
    }
}