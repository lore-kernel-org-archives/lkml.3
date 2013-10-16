Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab3JPMcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:32:08 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42208 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934329Ab3JPMcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 10/16] m68k/UAPI: Move Amiga model/chipset definitions to <asm/bootinfo-amiga.h>
Date: Wed, 16 Oct 2013 14:31:27 +0200
Message-Id: <1381926693-6392-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/include/asm/amigahw.h             |   26 +---------------------
 arch/m68k/include/uapi/asm/bootinfo-amiga.h |   32 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/arch/m68k/include/asm/amigahw.h b/arch/m68k/include/asm/amigahw.h
index 3bef0b2ad945..5ad568110f17 100644
--- a/arch/m68k/include/asm/amigahw.h
+++ b/arch/m68k/include/asm/amigahw.h
@@ -18,26 +18,7 @@
 
 #include <linux/ioport.h>
 
-    /*
-     *  Different Amiga models
-     */
-
-#define AMI_UNKNOWN	(0)
-#define AMI_500		(1)
-#define AMI_500PLUS	(2)
-#define AMI_600		(3)
-#define AMI_1000	(4)
-#define AMI_1200	(5)
-#define AMI_2000	(6)
-#define AMI_2500	(7)
-#define AMI_3000	(8)
-#define AMI_3000T	(9)
-#define AMI_3000PLUS	(10)
-#define AMI_4000	(11)
-#define AMI_4000T	(12)
-#define AMI_CDTV	(13)
-#define AMI_CD32	(14)
-#define AMI_DRACO	(15)
+#include <asm/bootinfo-amiga.h>
 
 
     /*
@@ -46,11 +27,6 @@
 
 extern unsigned long amiga_chipset;
 
-#define CS_STONEAGE	(0)
-#define CS_OCS		(1)
-#define CS_ECS		(2)
-#define CS_AGA		(3)
-
 
     /*
      *  Miscellaneous
diff --git a/arch/m68k/include/uapi/asm/bootinfo-amiga.h b/arch/m68k/include/uapi/asm/bootinfo-amiga.h
index 2c32d671f232..28b6da07874a 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-amiga.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-amiga.h
@@ -22,6 +22,38 @@
 
 
     /*
+     *  Amiga models (BI_AMIGA_MODEL)
+     */
+
+#define AMI_UNKNOWN		0
+#define AMI_500			1
+#define AMI_500PLUS		2
+#define AMI_600			3
+#define AMI_1000		4
+#define AMI_1200		5
+#define AMI_2000		6
+#define AMI_2500		7
+#define AMI_3000		8
+#define AMI_3000T		9
+#define AMI_3000PLUS		10
+#define AMI_4000		11
+#define AMI_4000T		12
+#define AMI_CDTV		13
+#define AMI_CD32		14
+#define AMI_DRACO		15
+
+
+    /*
+     *  Amiga chipsets (BI_AMIGA_CHIPSET)
+     */
+
+#define CS_STONEAGE		0
+#define CS_OCS			1
+#define CS_ECS			2
+#define CS_AGA			3
+
+
+    /*
      *  Latest Amiga bootinfo version
      */
 
-- 
1.7.9.5

