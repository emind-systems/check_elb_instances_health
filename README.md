check_elb_instances_health
==========================

Nagios plugin to check the health of instances behind AWS ELB

Usage: 

  ./check_elb_instances.sh AWSAccessKeyId AWSSecretKey AWSRegion ELB_NAME
  
  ./check_elb_instances_v2 -k WS-AccessKeyId -s AWS-SecretKey -r AWS-Region -e LB_NAME

  Output: OK: ELB:MyTestELB Total:1 Healthy:1

==========================

Copyright 2013 Emind Systems Ltd - htttp://www.emind.co
This file is part of Emind Systems DevOps Tool set.
Emind Systems DevOps Tool set is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
Emind Systems DevOps Tool set is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with Emind Systems DevOps Tool set. If not, see http://www.gnu.org/licenses/.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/907c7de0b8e2be4bbc45ea33cbffe29d "githalytics.com")](http://githalytics.com/emind-systems/check_elb_instances_health)
