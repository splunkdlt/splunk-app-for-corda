# Splunk App for Corda (alpha)

## Docker-compose example

Start the network by running `./start.sh`.
This will start a local instance of Splunk and provision a three-node network with two conventional nodes (_Alice_, _Bob_), and a notary (_Notary_).

All nodes can be accessed via SSH with the user name `user` and password `secret`.
Nodes expose ports to the host system, so a connection can be made like this: `ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no user@localhost -p 10004`.

Once you're ssh'd into node 1, you can send a "Yo" to Node two by entering the following in the Corda node terminal: `flow start YoFlow target: Bob`

[Explore your data in Splunk](http://localhost:8000).

Stop with `./stop.sh`
