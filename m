Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3BAL6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:58:21 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31909 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab3BAL6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:18 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 4/6] metag: kernel/setup.c: sort includes
Date: Fri, 1 Feb 2013 11:49:08 +0000
Message-ID: <1359719350-24560-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
References: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort includes in kernel/setup.c.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/setup.c |   46 ++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 89f9cdc..aaebc56 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -5,43 +5,43 @@
  *
  */
 
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/sched.h>
+#include <linux/bootmem.h>
+#include <linux/console.h>
+#include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/interrupt.h>
+#include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/console.h>
 #include <linux/genhd.h>
-#include <linux/errno.h>
-#include <linux/string.h>
 #include <linux/init.h>
-#include <linux/bootmem.h>
-#include <linux/root_dev.h>
 #include <linux/initrd.h>
-#include <linux/seq_file.h>
-#include <linux/pfn.h>
-#include <linux/start_kernel.h>
-#include <linux/cpu.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/of_fdt.h>
+#include <linux/pfn.h>
+#include <linux/root_dev.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/start_kernel.h>
+#include <linux/string.h>
 
 #include <asm/cachepart.h>
 #include <asm/clock.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
-#include <asm/processor.h>
-#include <asm/traps.h>
-#include <asm/mmu.h>
+#include <asm/core_reg.h>
 #include <asm/cpu.h>
+#include <asm/da.h>
+#include <asm/highmem.h>
 #include <asm/hwthread.h>
-#include <asm/mmzone.h>
 #include <asm/l2cache.h>
-#include <asm/da.h>
-#include <asm/prom.h>
 #include <asm/mach/arch.h>
-#include <asm/core_reg.h>
-#include <asm/highmem.h>
+#include <asm/mmu.h>
+#include <asm/mmzone.h>
+#include <asm/processor.h>
+#include <asm/prom.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/traps.h>
 
 /* PRIV protect as many registers as possible. */
 #define DEFAULT_PRIV	0xff0f7f00
-- 
1.7.7.6


