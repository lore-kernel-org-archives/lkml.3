Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3HWPXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:23:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3HWPXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:23:46 -0400
Message-ID: <52177E80.7040809@ubuntu.com>
Date: Fri, 23 Aug 2013 16:23:44 +0100
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "upstart-de >> \"upstart-devel >> Upstart Devel List\"" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Upstart 1.10 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* upstart-local-bridge: New bridge for starting jobs on local
  socket connections.
* upstart-dconf-bridge: New bridge for Session Inits.
* upstart-dbus-bridge: New '--bus-name' option to allow bus name
  variable to be included in dbus-event(7).
* New "reload signal" stanza to allow jobs to specify a custom signal
  that will be sent to the main process (rather than the default SIGHUP).
* Inclusion of Session Init sample jobs.
* Re-exec fixes for handling chroot sessions.
* Shutdown fix for Session Inits.
* New python3 module and accompanying integration test suite for
  testing Upstart running as PID 1 and as a Session Init
  (priveleged and non-privileged).


Thanks to all the contributors, reviewers, testers and users.

Download it from launchpad: https://launchpad.net/upstart

Kind regards,

James.
--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel
