Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375Ab3DBLpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:45:14 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54633 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab3DBLpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:45:11 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 3/3] davinic: vpss: trivial cleanup
Date: Tue,  2 Apr 2013 17:14:04 +0530
Message-Id: <1364903044-13752-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

this patch removes unnecessary header file inclusions and
fixes the typo's.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpss.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index d36429d..8a2f01e 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -17,13 +17,8 @@
  *
  * common vpss system module platform driver for all video drivers.
  */
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
-#include <linux/compiler.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 
@@ -101,7 +96,7 @@ enum vpss_platform_type {
 
 /*
  * vpss operations. Depends on platform. Not all functions are available
- * on all platforms. The api, first check if a functio is available before
+ * on all platforms. The api, first check if a function is available before
  * invoking it. In the probe, the function ptrs are initialized based on
  * vpss name. vpss name can be "dm355_vpss", "dm644x_vpss" etc.
  */
@@ -116,7 +111,7 @@ struct vpss_hw_ops {
 	void (*set_sync_pol)(struct vpss_sync_pol);
 	/* set the PG_FRAME_SIZE register*/
 	void (*set_pg_frame_size)(struct vpss_pg_frame_size);
-	/* check and clear interrupt if occured */
+	/* check and clear interrupt if occurred */
 	int (*dma_complete_interrupt)(void);
 };
 
@@ -235,7 +230,7 @@ EXPORT_SYMBOL(vpss_clear_wbl_overflow);
 
 /*
  *  dm355_enable_clock - Enable VPSS Clock
- *  @clock_sel: CLock to be enabled/disabled
+ *  @clock_sel: Clock to be enabled/disabled
  *  @en: enable/disable flag
  *
  *  This is called to enable or disable a vpss clock
-- 
1.7.4.1

