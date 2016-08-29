gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-EOS # remember to close this block with 'EOS' below
main: # 'main' is the GitLab 'provider ID' of this LDAP server
  ## label
  #
  # A human-friendly name for your LDAP server. It is OK to change the label later,
  # for instance if you find out it is too large to fit on the web page.
  #
  # Example: 'Paris' or 'Acme, Ltd.'



  ############################################################################################
  #                           THIS IS HOW YOU CAN TEST LDAP CONFIG
  #
  #         gitlab-rake gitlab:ldap:check RAILS_ENV
  #
  ###############################################

  label: 'LDAP'

  host: '{{ ci_host_name }}'
  port: 4000
  uid: 'uid'
  method: 'plain' # "tls" or "ssl" or "plain"
  bind_dn: 'cn=admin,dc={{ ci_host_name }}'
  password: '{{ initial_admin_password }}'
  ############################################################################################
  #                           THIS IS HOW YOU CAN TEST LDAP CONFIG
  #
  #         gitlab-rake gitlab:ldap:check RAILS_ENV
  #
  ###############################################
  # Set a timeout, in seconds, for LDAP queries. This helps avoid blocking
  # a request if the LDAP server becomes unresponsive.
  # A value of 0 means there is no timeout.
  timeout: 10

  # This setting specifies if LDAP server is Active Directory LDAP server.
  # For non AD servers it skips the AD specific queries.
  # If your LDAP server is not AD, set this to false.
  active_directory: false

  # If allow_username_or_email_login is enabled, GitLab will ignore everything
  # after the first '@' in the LDAP username submitted by the user on login.
  #
  # Example:
  # - the user enters 'jane.doe@example.com' and 'p@ssw0rd' as LDAP credentials;
  # - GitLab queries the LDAP server with 'jane.doe' and 'p@ssw0rd'.
  #
  # If you are using "uid: 'userPrincipalName'" on ActiveDirectory you need to
  # disable this setting, because the userPrincipalName contains an '@'.
  allow_username_or_email_login: false

  # To maintain tight control over the number of active users on your GitLab installation,
  # enable this setting to keep new users blocked until they have been cleared by the admin
  # (default: false).
  block_auto_created_users: false

  # Base where we can search for users
  #
  #   Ex. ou=People,dc=gitlab,dc=example
  #
  base: 'ou=People,dc={{ ci_host_name }}'

  # Filter LDAP users
  #
  #   Format: RFC 4515 https://tools.ietf.org/search/rfc4515
  #   Ex. (employeeType=developer)
  #
  #   Note: GitLab does not support omniauth-ldap's custom filter syntax.
  #
  user_filter: ''

  # LDAP attributes that GitLab will use to create an account for the LDAP user.
  # The specified attribute can either be the attribute name as a string (e.g. 'mail'),
  # or an array of attribute names to try in order (e.g. ['mail', 'email']).
  # Note that the user's LDAP login will always be the attribute specified as `uid` above.
  attributes:
    # The username will be used in paths for the user's own projects
    # (like `gitlab.example.com/username/project`) and when mentioning
    # them in issues, merge request and comments (like `@username`).
    # If the attribute specified for `username` contains an email address,
    # the GitLab username will be the part of the email address before the '@'.
    username: ['uid', 'userid', 'sAMAccountName']
    email:    ['mail', 'email', 'userPrincipalName']

    # If no full name could be found at the attribute specified for `name`,
    # the full name is determined using the attributes specified for
    # `first_name` and `last_name`.
    name:       'cn'
    first_name: 'givenName'
    last_name:  'sn'

  ## EE only

  # Base where we can search for groups
  #
  #   Ex. ou=groups,dc=gitlab,dc=example
  #
  group_base: ''

  # The CN of a group containing GitLab administrators
  #
  #   Ex. administrators
  #
  #   Note: Not `cn=administrators` or the full DN
  #
  admin_group: ''

  # The LDAP attribute containing a user's public SSH key
  #
  #   Ex. ssh_public_key
  #
  sync_ssh_keys: false

# GitLab EE only: add more LDAP servers
# Choose an ID made of a-z and 0-9 . This ID will be stored in the database
# so that GitLab can remember which LDAP server a user belongs to.
# uswest2:
#   label:
#   host:
#   ....
EOS