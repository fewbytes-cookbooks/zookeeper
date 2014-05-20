maintainer       "GoTime Inc."
maintainer_email "ops@gotime.com"
license          "Apache 2.0"
description      "Installs/Configures zookeeper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.3.0"
name             "zookeeper"

recipe "zookeeper::default", "Installs and configures zookeeper"
recipe "zookeeper::ebs_volume", "Attaches or creates an EBS volume for zookeeper"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "java"
depends "runit", ">= 1.0.0"
depends "ark"
depends "partial_search"
depends "aws"
depends "xfs"