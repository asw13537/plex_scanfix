#!/bin/bash

# Variables
PLEX_DATABASE_PATH="Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db" # Full path to PLEX DB
PLEX_TOKEN="plex_token" # Plex Token -- Can use PLEX_AUTOSCAN Token
PLEX_URL="hplexurl" # URL to PLEX Server (must be reachable)
PLEX_MOVIE_SECTION_ID="1" # Set this to SECTION ID of Movies

## DO NOT EDIT THE BELOW UNLESS YOU KNOW WHAT YOU ARE DOING

QUERY="SELECT   id
FROM     metadata_items
WHERE    id NOT IN
         (
                SELECT metadata_item_id
                FROM   taggings)
AND      metadata_type IS NOT 18
AND      library_section_id IS $PLEX_MOVIE_SECTION_ID
ORDER BY title ASC;"

for id in $(sqlite3 "$PLEX_DATABASE_PATH" "$QUERY"); do
  curl -s -X PUT -i '$PLEX_URL/library/metadata/$id/refresh?X-Plex-Token=$PLEX_TOKEN'
  sleep 10
done
