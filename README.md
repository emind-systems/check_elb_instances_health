check_elb_instances_health
==========================

Nagios plugin to check the health of instances behind AWS ELB

Usage:

  ./check_elb_instances_health]$ ./check_elb_instances.sh MyTestELB

  Output: OK: ELB:MyTestELB Total:5 Healthy:5 Critical:0 Warning:5 | Total=5 Healthy=5 Critical=0 Warning=5

  .check_elb_instances_health]$ ./check_elb_instances.sh -w3 -c1 MyTestELB

   Output: OK: ELB:MyTestELB Total:5 Healthy:5 Critical:1 Warning:3 | Total=5 Healthy=5 Critical=1 Warning=3

License
-------

See the [LICENSE](LICENSE.md) file for license rights and limitations.
