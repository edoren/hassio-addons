# Gotify Server Addon

## Options

### database_dialect
- Type: list
- Default: `sqlite3`
- Required: yes
- Description: Database engine to use. Supported values: `sqlite3`, `mysql`, `postgres`.

### database_connection
- Type: string (optional)
- Default: `""`
- Required: no
- Description: Full connection string for the chosen dialect. For sqlite this should remain empty to use the bundled file.

### password_strength
- Type: int
- Default: `10`
- Required: no
- Description: Minimum password strength/length enforced by Gotify. The schema suggests a minimum of 8.

### registration
- Type: bool
- Default: `false`
- Required: no
- Description: Allow public account registration.

## First Login
https://gotify.net/docs/first-login

## Example

```yaml
database_dialect: sqlite3
database_connection: ""
password_strength: 10
registration: false
```
