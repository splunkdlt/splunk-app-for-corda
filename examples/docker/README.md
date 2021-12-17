# Splunk App for Corda (alpha)

## Docker-compose example
This demo launches a local instance of Splunk and a three-node network with two conventional nodes (_Alice_, _Bob_), and a notary (_Notary_).

## Startup
Start the network by running `./start.sh`.

## Sending Transactions
All nodes can be accessed via SSH with the user name `user` and password `secret`.
Nodes expose ports to the host system, so a connection can be made like this:

```console
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no user@localhost -p 10004
```

Once you're ssh'd into node 1, you can send a "Yo" to Node two by entering the following in the Corda node terminal:
```console
flow start YoFlow target: Bob
```

You should see output similar to:
```console
 ✓ Starting
 ✓ Creating a new Yo!
 ✓ Verifying the Yo!
 ✓ Verifying the Yo!
 ✓ Sending the Yo!
          Requesting signature by notary service
              Requesting signature by Notary service
              Validating response from Notary service
     ✓ Broadcasting transaction to participants
▶︎ Done
Flow completed with result: SignedTransaction(id=96D2425848C887E9031A0C7409756914EF1E79372C37783070A3D5FA8EA38230)
```

To view the flow analysis for this transaction, copy the resulting transaction id into the [Flow Analysis Dashboard](http://localhost:8000/en-US/app/Splunk_App_for_Corda/flow_analytics).

## Explore in Splunk
The installed [Splunk App for Corda](http://localhost:8000/en-US/app/Splunk_App_for_Corda/intro) contains a few example dashboards to help you visualize your data.

**Note:** Some corda metrics like cache and p2p are only available in Corda Enterprise; dashboards relying on those metrics will not populate if using the open source version.

## Cleanup
Stop with `./stop.sh`
