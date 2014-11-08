Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaKHIzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 03:55:01 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57622 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaKHIy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 03:54:59 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: power: Fix typo in Documentation/power
Date: Sat,  8 Nov 2014 17:54:51 +0900
Message-Id: <1415436891-28182-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typos found in Documentation/power.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/power/runtime_pm.txt             | 6 +++---
 Documentation/power/suspend-and-interrupts.txt | 2 +-
 Documentation/power/userland-swsusp.txt        | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index f32ce54..0e5ea26 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -229,13 +229,13 @@ defined in include/linux/pm.h:
     - if set, the value of child_count is ignored (but still updated)
 
   unsigned int disable_depth;
-    - used for disabling the helper funcions (they work normally if this is
+    - used for disabling the helper functions (they work normally if this is
       equal to zero); the initial value of it is 1 (i.e. runtime PM is
       initially disabled for all devices)
 
   int runtime_error;
     - if set, there was a fatal error (one of the callbacks returned error code
-      as described in Section 2), so the helper funtions will not work until
+      as described in Section 2), so the helper functions will not work until
       this flag is cleared; this is the error code returned by the failing
       callback
 
@@ -524,7 +524,7 @@ pm_runtime_put_sync_autosuspend()
 5. Runtime PM Initialization, Device Probing and Removal
 
 Initially, the runtime PM is disabled for all devices, which means that the
-majority of the runtime PM helper funtions described in Section 4 will return
+majority of the runtime PM helper functions described in Section 4 will return
 -EAGAIN until pm_runtime_enable() is called for the device.
 
 In addition to that, the initial runtime PM status of all devices is
diff --git a/Documentation/power/suspend-and-interrupts.txt b/Documentation/power/suspend-and-interrupts.txt
index 6966364..2f9c5a5 100644
--- a/Documentation/power/suspend-and-interrupts.txt
+++ b/Documentation/power/suspend-and-interrupts.txt
@@ -77,7 +77,7 @@ Calling enable_irq_wake() causes suspend_device_irqs() to treat the given IRQ
 in a special way.  Namely, the IRQ remains enabled, by on the first interrupt
 it will be disabled, marked as pending and "suspended" so that it will be
 re-enabled by resume_device_irqs() during the subsequent system resume.  Also
-the PM core is notified about the event which casues the system suspend in
+the PM core is notified about the event which causes the system suspend in
 progress to be aborted (that doesn't have to happen immediately, but at one
 of the points where the suspend thread looks for pending wakeup events).
 
diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.txt
index 0e87082..bbfcd1bb 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -99,7 +99,7 @@ SNAPSHOT_S2RAM - suspend to RAM; using this call causes the kernel to
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:
 - you cannot read() more than one virtual memory page at a time
-- read()s across page boundaries are impossible (ie. if ypu read() 1/2 of
+- read()s across page boundaries are impossible (ie. if you read() 1/2 of
 	a page in the previous call, you will only be able to read()
 	_at_ _most_ 1/2 of the page in the next call)
 
-- 
2.2.0.rc1

