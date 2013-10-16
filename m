Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430Ab3JPMdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:33:03 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42411 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934343Ab3JPMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 16/16] m68k: Remove superfluous inclusions of <asm/bootinfo.h>
Date: Wed, 16 Oct 2013 14:31:33 +0200
Message-Id: <1381926693-6392-17-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/iop.c                     |    1 -
 arch/m68k/mac/misc.c                    |    1 -
 arch/m68k/mac/oss.c                     |    1 -
 arch/m68k/mac/psc.c                     |    1 -
 arch/m68k/mac/via.c                     |    1 -
 arch/m68k/sun3x/prom.c                  |    1 -
 drivers/net/ethernet/natsemi/macsonic.c |    1 -
 drivers/video/macfb.c                   |    1 -
 drivers/video/valkyriefb.c              |    1 -
 9 files changed, 9 deletions(-)

diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index ed0d9b0473ea..4d2adfb32a2a 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -111,7 +111,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 
-#include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_iop.h>
diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index 3d02a3c3a93a..707b61aea203 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -25,7 +25,6 @@
 #include <asm/mac_via.h>
 #include <asm/mac_oss.h>
 
-#include <asm/bootinfo.h>
 #include <asm/machdep.h>
 
 /* Offset between Unix time (1970-based) and Mac time (1904-based) */
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index 6c4c882c126e..54037125ebf8 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -21,7 +21,6 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 
-#include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_via.h>
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index cc9f3f097be7..835fa04511c8 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -21,7 +21,6 @@
 #include <linux/irq.h>
 
 #include <asm/traps.h>
-#include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_psc.h>
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 5d1458bb871b..e198dec868e4 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 
-#include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_via.h>
diff --git a/arch/m68k/sun3x/prom.c b/arch/m68k/sun3x/prom.c
index a7b7e818d627..0898c3f81508 100644
--- a/arch/m68k/sun3x/prom.c
+++ b/arch/m68k/sun3x/prom.c
@@ -10,7 +10,6 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/bootinfo.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
 #include <asm/sun3xprom.h>
diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 346a4e025c34..04b3ec1352f1 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -52,7 +52,6 @@
 #include <linux/bitrev.h>
 #include <linux/slab.h>
 
-#include <asm/bootinfo.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
diff --git a/drivers/video/macfb.c b/drivers/video/macfb.c
index fe01add3700e..945779cc7672 100644
--- a/drivers/video/macfb.c
+++ b/drivers/video/macfb.c
@@ -34,7 +34,6 @@
 #include <linux/fb.h>
 
 #include <asm/setup.h>
-#include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #include <asm/io.h>
 
diff --git a/drivers/video/valkyriefb.c b/drivers/video/valkyriefb.c
index 3f5a041601da..88f911e9e612 100644
--- a/drivers/video/valkyriefb.c
+++ b/drivers/video/valkyriefb.c
@@ -56,7 +56,6 @@
 #include <linux/cuda.h>
 #include <asm/io.h>
 #ifdef CONFIG_MAC
-#include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #else
 #include <asm/prom.h>
-- 
1.7.9.5

