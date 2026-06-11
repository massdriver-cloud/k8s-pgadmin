{
    "serverDefinitions": {
        "enabled": true,
        "resourceType": "Secret",

        "servers": {
            "primaryServer": {
                "Name": "Primary Server",
                "Group": "Servers",
                "Port": .database.authentication.port,
                "Username": .database.authentication.username,
                "Host": .database.authentication.hostname,
                "Password": .database.authentication.password,
                "SSLMode": "prefer",
                "MaintenanceDB": "postgres"
            }
        }
    }
}