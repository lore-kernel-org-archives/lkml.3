Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949Ab3DOReB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:34:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:59272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab3DORd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="318548587"
Date: Mon, 15 Apr 2013 10:33:34 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
Message-ID: <412f8f434c32c557b8c17e73163d003b895e2e56.1366046390.git.sarah.a.sharp@linux.intel.com>
References: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1366046390.git.sarah.a.sharp@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Outline how often it's polite to ping kernel maintainers about bugs, and
suggest that kernel maintainers should respond to bugs in 1 to 5
business days.

Emphasize that regressions, userspace breakage, and kernel crashes are
exceptions to that rule.  Suggest escalation to LKML and Linus if these
bugs are ignored during the merge window.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 REPORTING-BUGS |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index c1f6e43..327b33b 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -117,4 +117,44 @@ summary from [1.]>" for easy identification by the developers.
 [X.] Other notes, patches, fixes, workarounds:
 
 
-Thank you
+Follow up
+=========
+
+Expectations for bug reporters
+------------------------------
+
+Linux kernel maintainers expect bug reporters to be able to follow up on
+bug reports.  That may include running new tests, applying patches,
+recompiling your kernel, and/or re-triggering your bug.  The most
+frustrating thing for maintainers is for someone to report a bug, and then
+never follow up on a request to try out a fix.
+
+That said, it's still useful for a kernel maintainer to know a bug exists
+on a supported kernel, even if you can't follow up with retests.  Follow
+up reports, such as replying to the email thread with "I tried the latest
+kernel and I can't reproduce my bug anymore" are also helpful, because
+maintainers have to assume silence means things are still broken.
+
+Expectations for kernel maintainers
+-----------------------------------
+
+Linux kernel maintainers are busy, overworked human beings.  Some times
+they may not be able to address your bug in a day, a week, or two weeks.
+If they don't answer your email, they may be on vacation, or at a Linux
+conference.  Check the conference schedule at LWN.net for more info:
+	https://lwn.net/Calendar/
+
+In general, kernel maintainers take 1 to 5 business days to respond to
+bugs.  The majority of kernel maintainers are employed to work on the
+kernel, and they may not work on the weekends.  Maintainers are scattered
+around the world, and they may not work in your time zone.  Unless you
+have a high priority bug, please wait at least a week after the first bug
+report before sending the maintainer a reminder email.
+
+The exceptions to this rule are regressions, kernel crashes, security holes,
+or userspace breakage caused by new kernel behavior.  Those bugs should be
+addressed by the maintainers ASAP.  If you suspect a maintainer is not
+responding to these types of bugs in a timely manner (especially during a
+merge window), escalate the bug to LKML and Linus Torvalds.
+
+Thank you!
-- 
1.7.9

