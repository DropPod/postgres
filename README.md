# The `postgres` Type #

This module provides a basic type for managing the installation and setup of PostreSQL.

## Example ##

``` puppet
postgres::user { "myapp": password => passwordgen('myapp') }
postgres::database { "myapp-dev": user => 'myapp' }
```

## Caveats ##

This type is currently *incredibly* primitive.
