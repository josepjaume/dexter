# dexter

Dexter helps you organize your tv series with well, you know... Dexterity}

It automatically detects all video files that seem like a series and moves them
into an appropriate path.

Currently in hard alpha but functional.

## Usage

    $ dexter

It organizes all the files within the current directory and its subdirectories and places them into appropriate folders

    $ dexter --input <input> --output <output>

Checks all the directories and subdirectories in <input> and creates a folder structure moving the files in <output>

    $ dexter --format ":name/S:season/:name S:seasonE:episode.:extension" 

Moves the files using the format specified.

    $ dexter --verbose no

Removes all output
