Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaGOSSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:18:34 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50402 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614AbaGOSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:18:30 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] alpha: Remove whiterrors related to uneeded characters and lines
Date: Tue, 15 Jul 2014 14:18:19 -0400
Message-Id: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file has multipe cleanpatch errors. This patch is the first in
a series to clean them up. This one removes uneeded characters and
lines from this file.
---
 arch/alpha/boot/bootpz.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index d6ad191..64a0da6 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -70,7 +70,7 @@ find_pa(unsigned long address)
 	result <<= 13;
 	result |= address & 0x1fff;
 	return result;
-}	
+}
 
 int
 check_range(unsigned long vstart, unsigned long vend,
@@ -199,14 +199,14 @@ extern char _end;
 
 	START_ADDR	KSEG address of the entry point of kernel code.
 
-	ZERO_PGE	KSEG address of page full of zeroes, but 
+	ZERO_PGE	KSEG address of page full of zeroes, but
 			upon entry to kerne cvan be expected
 			to hold the parameter list and possible
 			INTRD information.
 
    These are used in the local defines below.
 */
-  
+
 
 /* Virtual addresses for the BOOTP image. Note that this includes the
    bootstrapper code as well as the compressed kernel image, and
@@ -229,7 +229,7 @@ extern char _end;
 #define V_DATA_START		KERNEL_ORIGIN
 #define V_INITRD_START		(KERNEL_ORIGIN + KERNEL_Z_SIZE)
 #define V_INTRD_END		(V_INITRD_START + REAL_INITRD_SIZE)
-#define V_DATA_END	 	V_BOOT_IMAGE_END
+#define V_DATA_END		V_BOOT_IMAGE_END
 
 /* KSEG addresses for the uncompressed kernel.
 
@@ -296,7 +296,7 @@ start_kernel(void)
 	/* Validity check the HWRPB. */
 	if (INIT_HWRPB->pagesize != 8192) {
 		srm_printk("Expected 8kB pages, got %ldkB\n",
-		           INIT_HWRPB->pagesize >> 10);
+	INIT_HWRPB->pagesize >> 10);
 		return;
 	}
 	if (INIT_HWRPB->vptb != (unsigned long) VPTB) {
@@ -443,7 +443,7 @@ start_kernel(void)
 		memcpy((void *)K_KERNEL_IMAGE_START,
 		       (void *)uncompressed_image_start, KERNEL_SIZE);
 	}
-	
+
 	/* Clear the zero page, then move the argument list in. */
 #ifdef DEBUG_LAST_STEPS
 	srm_printk("Preparing ZERO_PGE...\n");
-- 
1.9.1

