Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab3CVO6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:58:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933680Ab3CVO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:58:52 -0400
Message-ID: <514C71AA.7090900@ubuntu.com>
Date: Fri, 22 Mar 2013 14:58:50 +0000
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "upstart-devel >> \"upstart-devel >> Upstart Devel List\"" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Upstart 1.8 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hot on the heels of v1.7, this new release adds two interesting new features:

- upstart-file-bridge: a new bridge that allows jobs to react to file
  events.

  Examples:

  # Event emitted when file is created, modified or deleted
  start on file FILE=/run/app.pid

  # Event emitted when file is created (only)
  start on file FILE=/run/app.pid EVENT=created

  # Event emitted when files within a directory are created,
  # modified or deleted.
  start on file FILE=/var/log/

  # Event emitted when files that match a glob pattern are
  # created in the indicated directory.
  start on file FILE=/var/crash/*.crash EVENT=created

  See upstart-file-bridge(8) and file-event(7) for further details.


- upstart-monitor: a very simple tool (*) that can run in either CLI or
  GUI mode either connected to PID 1 or a Session Init (as root or
  non-root) that allows users and admins to see event flows.

  See upstart-monitor(8) for further details (and [1] for obligatory screenshot).


Thanks to all involved!

Download Upstart 1.8 from launchpad: https://launchpad.net/upstart


Kind regards,

James.

(*) - If you are interested in contributing to Upstart, we'd love to hear from
you. Now is a great time to get involved, since with the advent of the
upstart-monitor the fun expands to include GUI hackers too ;-)

[1] -
http://ifdeflinux.blogspot.co.uk/2013/03/a-basic-upstart-events-gui-and-cli-tool.html
--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel

