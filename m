Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3HMUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:21:52 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13015 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab3HMUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:29 -0400
Message-ID: <201308132020.r7DKKSvF022751@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 15:24:14 -0400
Subject: [PATCH] tile: change <asm/system.h> to <asm/switch_to.h> in comments
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix mentions of it in #error statements.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/regs_32.S | 4 ++--
 arch/tile/kernel/regs_64.S | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/tile/kernel/regs_32.S b/arch/tile/kernel/regs_32.S
index c12280c..542cae1 100644
--- a/arch/tile/kernel/regs_32.S
+++ b/arch/tile/kernel/regs_32.S
@@ -20,7 +20,7 @@
 #include <asm/switch_to.h>
 
 /*
- * See <asm/system.h>; called with prev and next task_struct pointers.
+ * See <asm/switch_to.h>; called with prev and next task_struct pointers.
  * "prev" is returned in r0 for _switch_to and also for ret_from_fork.
  *
  * We want to save pc/sp in "prev", and get the new pc/sp from "next".
@@ -39,7 +39,7 @@
  */
 
 #if CALLEE_SAVED_REGS_COUNT != 24
-# error Mismatch between <asm/system.h> and kernel/entry.S
+# error Mismatch between <asm/switch_to.h> and kernel/entry.S
 #endif
 #define FRAME_SIZE ((2 + CALLEE_SAVED_REGS_COUNT) * 4)
 
diff --git a/arch/tile/kernel/regs_64.S b/arch/tile/kernel/regs_64.S
index 0829fd0..bbffcc6 100644
--- a/arch/tile/kernel/regs_64.S
+++ b/arch/tile/kernel/regs_64.S
@@ -20,7 +20,7 @@
 #include <asm/switch_to.h>
 
 /*
- * See <asm/system.h>; called with prev and next task_struct pointers.
+ * See <asm/switch_to.h>; called with prev and next task_struct pointers.
  * "prev" is returned in r0 for _switch_to and also for ret_from_fork.
  *
  * We want to save pc/sp in "prev", and get the new pc/sp from "next".
@@ -39,7 +39,7 @@
  */
 
 #if CALLEE_SAVED_REGS_COUNT != 24
-# error Mismatch between <asm/system.h> and kernel/entry.S
+# error Mismatch between <asm/switch_to.h> and kernel/entry.S
 #endif
 #define FRAME_SIZE ((2 + CALLEE_SAVED_REGS_COUNT) * 8)
 
-- 
1.8.3.1

