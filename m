Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab3JPMdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:33:45 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42128 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934333Ab3JPMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 12/16] m68k/UAPI: Move HP300 model definitions to <asm/bootinfo-hp300.h>
Date: Wed, 16 Oct 2013 14:31:29 +0200
Message-Id: <1381926693-6392-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/include/asm/hp300hw.h             |   20 ++------------------
 arch/m68k/include/uapi/asm/bootinfo-hp300.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/m68k/include/asm/hp300hw.h b/arch/m68k/include/asm/hp300hw.h
index d998ea67c19c..64f5271dd7be 100644
--- a/arch/m68k/include/asm/hp300hw.h
+++ b/arch/m68k/include/asm/hp300hw.h
@@ -1,25 +1,9 @@
 #ifndef _M68K_HP300HW_H
 #define _M68K_HP300HW_H
 
-extern unsigned long hp300_model;
+#include <asm/bootinfo-hp300.h>
 
-/* This information was taken from NetBSD */
-#define	HP_320		(0)	/* 16MHz 68020+HP MMU+16K external cache */
-#define	HP_330		(1)	/* 16MHz 68020+68851 MMU */
-#define	HP_340		(2)	/* 16MHz 68030 */
-#define	HP_345		(3)	/* 50MHz 68030+32K external cache */
-#define	HP_350		(4)	/* 25MHz 68020+HP MMU+32K external cache */
-#define	HP_360		(5)	/* 25MHz 68030 */
-#define	HP_370		(6)	/* 33MHz 68030+64K external cache */
-#define	HP_375		(7)	/* 50MHz 68030+32K external cache */
-#define	HP_380		(8)	/* 25MHz 68040 */
-#define	HP_385		(9)	/* 33MHz 68040 */
 
-#define	HP_400		(10)	/* 50MHz 68030+32K external cache */
-#define	HP_425T		(11)	/* 25MHz 68040 - model 425t */
-#define	HP_425S		(12)	/* 25MHz 68040 - model 425s */
-#define HP_425E		(13)	/* 25MHz 68040 - model 425e */
-#define HP_433T		(14)	/* 33MHz 68040 - model 433t */
-#define HP_433S		(15)	/* 33MHz 68040 - model 433s */
+extern unsigned long hp300_model;
 
 #endif /* _M68K_HP300HW_H */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-hp300.h b/arch/m68k/include/uapi/asm/bootinfo-hp300.h
index e7ed19cdafe5..08530e12d4c3 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-hp300.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-hp300.h
@@ -16,6 +16,31 @@
 
 
     /*
+     *  HP9000/300 and /400 models (BI_HP300_MODEL)
+     *
+     * This information was taken from NetBSD
+     */
+
+#define HP_320		0	/* 16MHz 68020+HP MMU+16K external cache */
+#define HP_330		1	/* 16MHz 68020+68851 MMU */
+#define HP_340		2	/* 16MHz 68030 */
+#define HP_345		3	/* 50MHz 68030+32K external cache */
+#define HP_350		4	/* 25MHz 68020+HP MMU+32K external cache */
+#define HP_360		5	/* 25MHz 68030 */
+#define HP_370		6	/* 33MHz 68030+64K external cache */
+#define HP_375		7	/* 50MHz 68030+32K external cache */
+#define HP_380		8	/* 25MHz 68040 */
+#define HP_385		9	/* 33MHz 68040 */
+
+#define HP_400		10	/* 50MHz 68030+32K external cache */
+#define HP_425T		11	/* 25MHz 68040 - model 425t */
+#define HP_425S		12	/* 25MHz 68040 - model 425s */
+#define HP_425E		13	/* 25MHz 68040 - model 425e */
+#define HP_433T		14	/* 33MHz 68040 - model 433t */
+#define HP_433S		15	/* 33MHz 68040 - model 433s */
+
+
+    /*
      *  Latest HP9000/300 bootinfo version
      */
 
-- 
1.7.9.5

