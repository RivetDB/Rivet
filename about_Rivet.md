# TOPIC

about_Rivet

# SHORT DESCRIPTION

Explains Rivet.

# LONG DESCRIPTION

Rivet is a database migration/change management/versioning tool.  It allows you to write migration scripts which describe changes you want to make to a database.  These scripts then get added to your version control system along with code that uses the new database changes.     

When you pull down the latest code (or deploy it to an environment), you can also apply the corresponding schema changes so that everything stays in sync.

Every Rivet migration is really a PowerShell script with a special name and  that contains two migration functions.  The migration filename should have the format `<timestamp>_<description>.ps1`.  Timestamp is a unique number which increases every time a new migration is created.  By default, Rivet uses a timestamp with second precision.  `Description` is a short description of what the migration is doing.

There should be two functions inside a migration, `Push-Migration` and `Pop-Migration`.  The `Push-Migration` function should make changes to the database.  The `Pop-Migration` function should reverse those changes, so you can put the database back in the state it was in before it was migrated. 

Once released, migrations are immutable and should not be changed.  Rivet keeps track of which migrations have been applied against a database.  If you change a migration once it has been applied to a database, it won't get re-applied because Rivet has already recorded that it was applied.  Create a new migration to make the new change.

All changes made in either `Push-Migration` or `Pop-Migration` are wrapped in a transaction.  If any change fails to get made/applied, all changes are rolled back.
    
# SEE ALSO

about_Rivet_migrations
