# docker-graylog

## Purpose

The container uses the base image graylog2/server:2.2.1-1 with one additional feature: it allows for a re-mapping of user id and group id
so that the main process outside the container has a valid UID and GID.

## Configuration
Follow these steps:

* create a desired user and a desired group on the host server (using e.g. `adduser`)
* add the following entries to your container environment (e.g. in `docker-compose.yaml`):
  * `TARGET_USERNAME: graylog`
  * `TARGET_UID: <UID>`
  * `TARGET_GROUPNAME: graylog`
  * `TARGET_GID: <GID>`
  where `<UID>` and `<GID>` have to be replaced by the ids used for the created host user and group respectively

## Example

There is a sample [`docker-compose.yaml`](docker-compose.yaml) to look at.
