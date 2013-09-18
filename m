Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3IREAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 00:00:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35266 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020Ab3IREAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 00:00:52 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [TRIVIAL] treewide: fix "distingush" typo
Date: Wed, 18 Sep 2013 06:00:43 +0200
Message-Id: <1379476843-5203-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/m32r/include/asm/mmu_context.h    | 2 +-
 arch/mn10300/include/asm/mmu_context.h | 2 +-
 arch/powerpc/platforms/pseries/nvram.c | 2 +-
 arch/sh/include/asm/mmu_context.h      | 2 +-
 arch/x86/kernel/cpu/amd.c              | 2 +-
 drivers/input/serio/i8042.c            | 2 +-
 drivers/md/raid5.h                     | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/m32r/include/asm/mmu_context.h b/arch/m32r/include/asm/mmu_context.h
index a979a41..9fc78fc 100644
--- a/arch/m32r/include/asm/mmu_context.h
+++ b/arch/m32r/include/asm/mmu_context.h
@@ -45,7 +45,7 @@ static inline void get_new_mmu_context(struct mm_struct *mm)
 		   Flush all TLB and start new cycle. */
 		local_flush_tlb_all();
 		/* Fix version if needed.
-		   Note that we avoid version #0 to distingush NO_CONTEXT. */
+		   Note that we avoid version #0 to distinguish NO_CONTEXT. */
 		if (!mc)
 			mmu_context_cache = mc = MMU_CONTEXT_FIRST_VERSION;
 	}
diff --git a/arch/mn10300/include/asm/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
index c67c2b5..75dbe69 100644
--- a/arch/mn10300/include/asm/mmu_context.h
+++ b/arch/mn10300/include/asm/mmu_context.h
@@ -71,7 +71,7 @@ static inline unsigned long allocate_mmu_context(struct mm_struct *mm)
 		local_flush_tlb_all();
 
 		/* fix the TLB version if needed (we avoid version #0 so as to
-		 * distingush MMU_NO_CONTEXT) */
+		 * distinguish MMU_NO_CONTEXT) */
 		if (!mc)
 			*pmc = mc = MMU_CONTEXT_FIRST_VERSION;
 	}
diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index d276cd3..10630ea 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -31,7 +31,7 @@
 #define NVRW_CNT 0x20
 
 /*
- * Set oops header version to distingush between old and new format header.
+ * Set oops header version to distinguish between old and new format header.
  * lnx,oops-log partition max size is 4000, header version > 4000 will
  * help in identifying new header.
  */
diff --git a/arch/sh/include/asm/mmu_context.h b/arch/sh/include/asm/mmu_context.h
index 21c5088..b9d9489 100644
--- a/arch/sh/include/asm/mmu_context.h
+++ b/arch/sh/include/asm/mmu_context.h
@@ -81,7 +81,7 @@ static inline void get_mmu_context(struct mm_struct *mm, unsigned int cpu)
 
 		/*
 		 * Fix version; Note that we avoid version #0
-		 * to distingush NO_CONTEXT.
+		 * to distinguish NO_CONTEXT.
 		 */
 		if (!asid)
 			asid = MMU_CONTEXT_FIRST_VERSION;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 903a264..3538a1b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -339,7 +339,7 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
 #endif
 
 /*
- * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
+ * On a AMD dual core setup the lower bits of the APIC id distinguish the cores.
  * Assumes number of cores is a power of two.
  */
 static void amd_detect_cmp(struct cpuinfo_x86 *c)
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 78e4de4..957e387 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1031,7 +1031,7 @@ static void i8042_controller_reset(bool force_reset)
 /*
  * i8042_panic_blink() will turn the keyboard LEDs on or off and is called
  * when kernel panics. Flashing LEDs is useful for users running X who may
- * not see the console and will help distingushing panics from "real"
+ * not see the console and will help distinguishing panics from "real"
  * lockups.
  *
  * Note that DELAY has a limit of 10ms so we will not get stuck here
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2113ffa..b42e6b4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -49,7 +49,7 @@
  * can't distinguish between a clean block that has been generated
  * from parity calculations, and a clean block that has been
  * successfully written to the spare ( or to parity when resyncing).
- * To distingush these states we have a stripe bit STRIPE_INSYNC that
+ * To distinguish these states we have a stripe bit STRIPE_INSYNC that
  * is set whenever a write is scheduled to the spare, or to the parity
  * disc if there is no spare.  A sync request clears this bit, and
  * when we find it set with no buffers locked, we know the sync is
-- 
1.8.1.2

