Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3CDMV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:21:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3CDMV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:21:26 -0500
Message-ID: <513491C3.9060402@ubuntu.com>
Date: Mon, 04 Mar 2013 12:21:23 +0000
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: "upstart-devel >> \"upstart-devel >> Upstart Devel List\"" 
	<upstart-devel@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Upstart 1.7 released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* New initctl commands: set-env, unset-env, get-env, list-env,
  reset-env, list-sessions (all except last with corresponding
  D-Bus methods).
* New D-Bus-only signals EventEmitted, Restarted, and EndSession method.
* Ability to run with PID >1 to allow Upstart to manage a user session.
  Running Upstart as a 'Session Init' in this way provides features
  above and beyond those provided by the original User Jobs such that
  the User Job facility has been removed entirely: to migrate from
  a system using User Jobs, simply ensure the user session is started with
  'init --user'.
* New upstart-event-bridge bridge which proxies system-level events down
  to Session Inits, allowing users jobs to react to udev events.
* Ability to read job configuration and override files from multiple
  freedesktop-compliant locations (Session Init only).
* Ability to shutdown both via a system shutdown request and via a user
  logout request (Session Init only).
* Additionally, there are a few bug fixes and 94 new tests.

Thanks to all the contributors, reviewers, testers and users.

Download it from launchpad: https://launchpad.net/upstart

Kind regards,

James.
--
James Hunt
____________________________________
http://upstart.ubuntu.com/cookbook
http://upstart.ubuntu.com/cookbook/upstart_cookbook.pdf
