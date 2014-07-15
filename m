Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaGODrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:47:11 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34732 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbaGODqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:46:50 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] alpha: Remove whitespace issues and turn spaces into tabs
Date: Mon, 14 Jul 2014 23:46:38 -0400
Message-Id: <1405396000-4917-3-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405396000-4917-1-git-send-email-xerofoify@gmail.com>
References: <1405396000-4917-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all the whitespace an tab issues that this file
has when running checkpatch
---
 arch/alpha/boot/bootp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/boot/bootp.c b/arch/alpha/boot/bootp.c
index 3ee529d..6227e4f 100644
--- a/arch/alpha/boot/bootp.c
+++ b/arch/alpha/boot/bootp.c
@@ -48,7 +48,7 @@ find_pa(unsigned long *vptb, void *ptr)
 	result <<= 13;
 	result |= address & 0x1fff;
 	return (void *) result;
-}	
+}
 
 /*
  * This function moves into OSF/1 pal-code, and has a temporary
@@ -152,7 +152,7 @@ start_kernel(void)
 	srm_printk("Linux/AXP bootp loader for Linux " UTS_RELEASE "\n");
 	if (INIT_HWRPB->pagesize != 8192) {
 		srm_printk("Expected 8kB pages, got %ldkB\n",
-		           INIT_HWRPB->pagesize >> 10);
+	INIT_HWRPB->pagesize >> 10);
 		return;
 	}
 	if (INIT_HWRPB->vptb != (unsigned long) VPTB) {
@@ -162,7 +162,7 @@ start_kernel(void)
 	}
 	pal_init();
 
-	/* The initrd must be page-aligned.  See below for the 
+	/* The initrd must be page-aligned.  See below for the
 	   cause of the magic number 5.  */
 	initrd_start = ((START_ADDR + 5*KERNEL_SIZE + PAGE_SIZE) |
 			(PAGE_SIZE-1)) + 1;
@@ -200,8 +200,8 @@ start_kernel(void)
 #ifdef INITRD_IMAGE_SIZE
 	load(initrd_start, KERNEL_ORIGIN+KERNEL_SIZE, INITRD_IMAGE_SIZE);
 #endif
-        load(START_ADDR+(4*KERNEL_SIZE), KERNEL_ORIGIN, KERNEL_SIZE);
-        load(START_ADDR, START_ADDR+(4*KERNEL_SIZE), KERNEL_SIZE);
+	load(START_ADDR+(4*KERNEL_SIZE), KERNEL_ORIGIN, KERNEL_SIZE);
+	load(START_ADDR, START_ADDR+(4*KERNEL_SIZE), KERNEL_SIZE);
 
 	memset((char*)ZERO_PGE, 0, PAGE_SIZE);
 	strcpy((char*)ZERO_PGE, envval);
-- 
1.9.1

