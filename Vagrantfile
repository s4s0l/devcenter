# -*- mode: ruby -*-
# vi: set ft=ruby :




# Defaults for config options
$cfg_hostname = 'devcenter'
$cfg_machine_name = 'Devcenter'
$cfg_ip = '10.10.0.22'
$cfg_persistent_storage_location = './.data/persistent_storage.vdi'
$cfg_initial_admin_password = 'admin123'
$cfg_initial_developer = ENV['USERNAME'] ? ENV['USERNAME'] : (ENV['USER'] ? ENV['USER'] : 'developer')
$cfg_initial_developer_password = 'Password1'
$cfg_initial_developer_key = (ENV["HOME"] ? ENV["HOME"] : ENV["HOMEPATH"]) + "/.ssh/id_rsa.pub"
$cfg_initial_developer_email = File.exist?($cfg_initial_developer_key) ? IO.read($cfg_initial_developer_key).split(" ")[2] : $cfg_initial_developer + '@' +  $cfg_hostname




#SETTINGS CUSTOMIZATION
require 'fileutils'
CONFIG = File.join(File.dirname(__FILE__), "settings.rb")
if File.exist?(CONFIG)
  puts "Will use customized user settings from settings.rb"
  require CONFIG
else
  puts "No settings.rb found if you want you can place overrides in it."
end

if !File.exist?('./.tmp/id_rsa.pub') then
  FileUtils.mkdir_p './.tmp'
  if File.exist?($cfg_initial_developer_key) then
    puts "Will use developer keys from " + $cfg_initial_developer_key
    FileUtils.cp $cfg_initial_developer_key, './.tmp'
  else
    puts "Generating developer keys in ./.tmp/id_rsa"
    `ssh-keygen -t rsa -C "#{$cfg_initial_developer_email}" -N "" -f ./.tmp/id_rsa`
  end
end



Vagrant.configure('2') do |config|
#HINT: after re-packering need to change name/invalidate cache whatsoever
  config.vm.box = 'packed-ubuntuz'
  config.vm.box_url = 'file://./baseimage/box/virtualbox/ubuntu1604-ansible-0.1.0.box'
  #this does not check if box file is updated:/
  config.vm.box_check_update = true
  config.vm.hostname = $cfg_hostname
  config.vm.network 'private_network', ip: $cfg_ip
  config.vm.provider 'virtualbox' do |v|
    v.name = $cfg_machine_name
  end

  # https://github.com/kusnier/vagrant-persistent-storage
  config.persistent_storage.enabled = true
  config.persistent_storage.location = $cfg_persistent_storage_location
  config.persistent_storage.size = 5000
  config.persistent_storage.mountname = 'persistent_storage'
  config.persistent_storage.filesystem = 'ext4'
  config.persistent_storage.mountpoint = '/data'
  config.persistent_storage.use_lvm = false

  config.vm.provision 'ansible_local' do |ansible|
      ansible.playbook = 'playbooks/playbook.yml'
      ansible.extra_vars = {
        ci_host_name: $cfg_hostname,
        ci_host_ip: $cfg_ip,
        ci_host_schared_folder: '/data',
        ci_machine_name: $cfg_machine_name,
        initial_admin_password: $cfg_initial_admin_password,
        initial_developer: $cfg_initial_developer,
        initial_developer_password: $cfg_initial_developer_password,
        initial_developer_email: $cfg_initial_developer_email
      }
  end
end
