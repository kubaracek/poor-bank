Holmust Test
====

### TLDR; how this works

 - Generate an infinite number of random values
   - Through conduit -> feed random into inverse CDF fn
   - Through conduit -> feed random into beta distribution fn
 - through conduit -> fold the (inv CDF, waiting time) to calculate a TimeSeries
   with queue times
 - Feed the timesheet to the Answers module that (a bit crudely) answers forty-two

### Notes

I hope I did the calculations correctly. However this ends, thanks.
That was a fun project to make :)

Due to the tight timeschedule, the final calculations are a bit crude and they
should be a conduit pipe themself -> the same way as the simulation is.

## Running

### Nix

For nix users, there's a `make run` or manually `nix-build release.nix && result/bin/exe`

### Stack

`stac run`
