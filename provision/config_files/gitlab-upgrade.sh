#!/bin/bash
(cd /usr/share/webapps/gitlab ; su -s /bin/sh gitlab -c "$(cat environment | xargs) bundle exec rake db:migrate")
systemctl start gitlab.target
