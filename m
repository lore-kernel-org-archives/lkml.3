Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbaGOSTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:19:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44456 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbaGOSSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:18:32 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] alpha: Remove all errors for checkpatch foo* bar
Date: Tue, 15 Jul 2014 14:18:21 -0400
Message-Id: <1405448304-3724-3-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
References: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes all issues with checkpatch relating to the asterisk
not being put next to the variable or structrue name and rather the
type of the declaring statement.
---
 arch/alpha/boot/bootpz.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index 15c16fe..0b5c978 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -42,10 +42,10 @@
 #undef DEBUG_LAST_STEPS
 
 extern unsigned long switch_to_osf_pal(unsigned long nr,
-	struct pcb_struct * pcb_va, struct pcb_struct * pcb_pa,
+	struct pcb_struct *pcb_va, struct pcb_struct *pcb_pa,
 	unsigned long *vptb);
 
-extern int decompress_kernel(void* destination, void *source,
+extern int decompress_kernel(void *destination, void *source,
 			     size_t ksize, size_t kzsize);
 
 extern void move_stack(unsigned long new_stack);
@@ -116,8 +116,8 @@ void
 pal_init(void)
 {
 	unsigned long i, rev;
-	struct percpu_struct * percpu;
-	struct pcb_struct * pcb_pa;
+	struct percpu_struct *percpu;
+	struct pcb_struct *pcb_pa;
 
 	/* Create the dummy PCB.  */
 	pcb_va->ksp = 0;
@@ -448,8 +448,8 @@ start_kernel(void)
 #ifdef DEBUG_LAST_STEPS
 	srm_printk("Preparing ZERO_PGE...\n");
 #endif
-	memset((char*)ZERO_PGE, 0, PAGE_SIZE);
-	strcpy((char*)ZERO_PGE, envval);
+	memset((char *)ZERO_PGE, 0, PAGE_SIZE);
+	strcpy((char *)ZERO_PGE, envval);
 
 #ifdef INITRD_IMAGE_SIZE
 
-- 
1.9.1

