#!/bin/bash

if [ -z $NEO4J_ADDR ] ; then
    echo "You must specify a NEO4J_ADDR env var"
    exit 1
fi

if [ -z $BUCKET ]; then
    echo "You must specify a BUCKET address such as gs://my-backups/"
    exit 1
fi

if [ -z $HEAP_SIZE ] ; then
    HEAP_SIZE=2G
fi

if [ -z $PAGE_CACHE ]; then
    PAGE_CACHE=4G
fi

if [ -z $BACKUP_NAME ]; then
    BACKUP_NAME=db-backup
fi

SYSTEM_DB_NAME="system"
BACKUP_SET="$BACKUP_NAME-$(date "+%Y-%m-%d-%H:%M:%S")"
SYSTEM_BACKUP_SET="$SYSTEM_DB_NAME-$(date "+%Y-%m-%d-%H:%M:%S")"

echo "Activating google credentials before beginning"
gcloud auth activate-service-account --key-file "$GOOGLE_APPLICATION_CREDENTIALS"

if [ $? -ne 0 ] ; then
    echo "Credentials failed; no way to copy to google."
    echo "Ensure GOOGLE_APPLICATION_CREDENTIALS is appropriately set."
fi

echo "=============== Neo4j Backup ==============================="
echo "Beginning backup from $NEO4J_ADDR to /data/$BACKUP_SET"
echo "Using heap size $HEAP_SIZE and page cache $PAGE_CACHE"
echo "To google storage bucket $BUCKET using credentials located at $GOOGLE_APPLICATION_CREDENTIALS"
echo "============================================================"

neo4j-admin backup \
    --from="$NEO4J_ADDR" \
    --backup-dir=/data \
    --database="$DB_NAME" \
    --pagecache=$PAGE_CACHE

neo4j-admin backup \
    --from="$NEO4J_ADDR" \
    --backup-dir=/data \
    --database="$SYSTEM_DB_NAME" \
    --pagecache=$PAGE_CACHE

echo "$DB_NAME Backup size:"
du -hs "/data/$DB_NAME"

echo "$SYSTEM_DB_NAME Backup size:"
du -hs "/data/$SYSTEM_DB_NAME"

echo "Tarring $SYSTEM_DB_NAME and $DB_NAME -> /data/$BACKUP_SET.tar"
tar -cvf "/data/$BACKUP_SET.tar" "/data/$DB_NAME" "/data/$SYSTEM_DB_NAME" --remove-files

echo "Zipping -> /data/$BACKUP_SET.tar.gz"
gzip -9 "/data/$BACKUP_SET.tar"

echo "Zipped backup size:"
du -hs "/data/$BACKUP_SET.tar.gz"

echo "Pushing /data/$BACKUP_SET.tar.gz -> $BUCKET"
gsutil cp "/data/$BACKUP_SET.tar.gz" "$BUCKET"

exit $?
