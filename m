Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3KNOwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:52:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3KNOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:51:54 -0500
Message-ID: <5284E382.9090900@ubuntu.com>
Date: Thu, 14 Nov 2013 14:51:46 +0000
From: James Hunt <james.hunt@ubuntu.com>
Reply-To: james.hunt@ubuntu.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "upstart-devel >> \"upstart-devel >> Upstart Devel List\"" 
	<upstart-devel@lists.ubuntu.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Upstart 1.11 released
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of changes:

* Add '--no-dbus' command-line option for the init(8) daemon (allowing
  event propagation to the Session Init via the upstart-event-bridge(8) to
  be disabled).
* Serialise Session Init job environment table on re-exec (LP: #1238078).
* upstart-{dbus,socket}-bridge(8): Don't clobber existing PATH (LP: #1234898).
* upstart-file-bridge(8):
  - Allow watching for directory creation (LP: #1221466).
  - Reduce default output.
* upstart-local-bridge(8): Handle arbitrary numbers of pairs and additional
  checks on input validity (LP: #1234898).
* Improved Session Init shutdown speed (LP: #1227212).
* New configure options: '--disable-local-bridge', '--disable-socket-bridge'.
* Added upstart-file-bridge(8) and Session Init re-exec integration tests.
* Retain umask for Session Init (LP: #1240686).
* Make Session Init connect to D-Bus Session Bus on request
  (LP: #1203595, #1235649)
* Improved build-time ABI compliance checking.
* Doc updates and lots of test refinements.

Thanks to all the contributors, reviewers, and testers.

Download it from launchpad: https://launchpad.net/upstart

--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel
