Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3HUTlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:41:05 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:36389 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3HUTlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:41:03 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: rob@landley.net
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH] power: Documentation: Update s2ram link
Date: Wed, 21 Aug 2013 21:40:46 +0200
Message-Id: <1377114046-10441-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s2ram link is broken because there is a new OpenSuse wiki online.
The page does no longer exist, it was merged in the Suspend_to_RAM
page.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>

diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
index 262acf5..e9b54de8 100644
--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.txt
@@ -179,7 +179,7 @@ use the PM_TRACE mechanism documented in Documentation/power/s2ram.txt .
 
 To verify that the STR works, it is generally more convenient to use the s2ram
 tool available from http://suspend.sf.net and documented at
-http://en.opensuse.org/SDB:Suspend_to_RAM.
+http://en.opensuse.org/SDB:Suspend_to_RAM (S2RAM_LINK).
 
 Namely, after writing "freezer", "devices", "platform", "processors", or "core"
 into /sys/power/pm_test (available if the kernel is compiled with
@@ -194,10 +194,10 @@ Among other things, the testing with the help of /sys/power/pm_test may allow
 you to identify drivers that fail to suspend or resume their devices.  They
 should be unloaded every time before an STR transition.
 
-Next, you can follow the instructions at http://en.opensuse.org/s2ram to test
-the system, but if it does not work "out of the box", you may need to boot it
-with "init=/bin/bash" and test s2ram in the minimal configuration.  In that
-case, you may be able to search for failing drivers by following the procedure
+Next, you can follow the instructions at S2RAM_LINK to test the system, but if
+it does not work "out of the box", you may need to boot it with
+"init=/bin/bash" and test s2ram in the minimal configuration.  In that case,
+you may be able to search for failing drivers by following the procedure
 analogous to the one described in section 1.  If you find some failing drivers,
 you will have to unload them every time before an STR transition (ie. before
 you run s2ram), and please report the problems with them.
-- 
1.7.9.5

