# Compliments, Please
 
A simple Godot application to receive random compliments by pressing a button.

## Installation

### Binary
You can download the binary of the application on itch.io:

[https://itch.io/](https://celdond.itch.io/compliments-please)

### Project
The application was built in Godot 4.4.1 using GDScript.

Simply clone the repository, and then import the project into Godot.

You can download Godot here:

https://godotengine.org/

## Use

Launch the game, and press the button to receive a compliment.

See the itch.io page for previews.

## Adding Additional Compliments

The application comes with a pool of 78 compliments that are randomly chosen from everytime you click the button.

Compliments are stored in a SQLite file located in the `data/content` folder with the name `compliments_database.db`.

Additional compliments can be added by inserting additional rows to the `Standard` table.

### Note on SQL Structure:

The random select functionality the application uses depends on the `id` column having an appropriate number for the range defined by the number of rows.
In other words, the ids need to increment appropriately with the rows.

For example, in the case there are 100 compliments, the values in the `id` column should include every number from 1 to 100.

In the case the database does not adhere to this constraint, there will be issues when pressing the button in the application.

## Exporting Binary

The Godot Documentation here can be followed to export the project when ready:

https://docs.godotengine.org/en/4.4/tutorials/export/exporting_projects.html#export-menu

Note in the `export_presets.cfg` that `*.db` must be in the `include_filter` setting for the database to be included in the export.
