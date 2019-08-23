
#sdfsdfsdfsdfsdfsd

# Cookbook:: custom_apache
# Recipe:: default
#
# Copyright:: (c) 2015-2018 The Authors, All Rights Reserved.

#################################################
# This demonstrates CHEF-4: Some Attribute Methods.
# https://docs.chef.io/deprecations_attributes.html
#################################################

# Load from node attributes some variables we'll need.
site_name = node['site']['name']
content_owner = node['site']['content']['owner']
content_group = node['site']['content']['group']

# Ensure the apt cache is up-to-date.
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

#################################################
# This demonstrates CHEF-3694: resource cloning
# https://docs.chef.io/deprecations_resource_cloning.html
#################################################

# Install additional Apache packages.
package %w( libapache2-modsecurity libapache2-mod-spamhaus )

# Create the group that owns web content.
group content_group do
  action :create
end

#################################################
# This demonstrates CHEF-8: "Supports" metaproperty
# https://docs.chef.io/deprecations_supports_property.html
#################################################

# Create the user that owns web content.
user content_owner do
  group content_group
  home "/home/#{content_owner}"
  shell '/bin/bash'
  manage_home true
  non_unique false
end

# Use the custom site resource to configure the website.
custom_apache_site site_name do
  homepage '<h1>Hello world!</h1>'
end

# Configure the homepage owner.
file '/var/www/html/index.html' do
  owner content_owner
  group content_group
  mode '644'
end

# Configure the web content directory owner.
directory '/var/www/html' do
  owner content_owner
  group content_group
  mode '755'
end
