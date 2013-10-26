Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3JZVMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 17:12:32 -0400
Received: from cocytus.austad.us ([176.58.107.48]:50001 "EHLO
	cocytus.austad.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JZVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 17:12:30 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Oct 2013 17:12:30 EDT
From: Henrik Austad <henrik@austad.us>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Henrik Austad <haustad@cisco.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] Documentation: add missing files to timers/00-INDEX
Date: Sat, 26 Oct 2013 23:04:12 +0200
Message-Id: <1382821452-24524-1-git-send-email-henrik@austad.us>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <haustad@cisco.com>

- timers-howto was added by commit 0fcb8081 (Documentation: Add
  timers/timers-howto.txt)
- NO_HZ was added by commit 0c87f9b5 (nohz_full: Add documentation.)

Cc: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Henrik Austad <haustad@cisco.com>
---
 Documentation/timers/00-INDEX |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
index a9248da..ef2ccbf 100644
--- a/Documentation/timers/00-INDEX
+++ b/Documentation/timers/00-INDEX
@@ -8,5 +8,9 @@ hpet_example.c
 	- sample hpet timer test program
 hrtimers.txt
 	- subsystem for high-resolution kernel timers
+NO_HZ.txt
+	- Summary of the different methods for the scheduler clock-interrupts management.
+timers-howto.txt
+	- how to insert delays in the kernel the right (tm) way.
 timer_stats.txt
 	- timer usage statistics
-- 
1.7.2.5

