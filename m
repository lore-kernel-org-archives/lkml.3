Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaGOSSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:18:44 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63304 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbaGOSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:18:33 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] alpha: Fix spaces to tabs
Date: Tue, 15 Jul 2014 14:18:20 -0400
Message-Id: <1405448304-3724-2-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
References: <1405448304-3724-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all errors for this file related to using spaces
instead of tabs.
---
 arch/alpha/boot/bootpz.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index 64a0da6..15c16fe 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -252,11 +252,11 @@ extern char _end;
 #define K_COPY_IMAGE_START	NEXT_PAGE(K_KERNEL_IMAGE_END)
 /* Reserve one page below INITRD for the new stack. */
 #define K_INITRD_START \
-    NEXT_PAGE(K_COPY_IMAGE_START + KERNEL_SIZE + PAGE_SIZE)
+	NEXT_PAGE(K_COPY_IMAGE_START + KERNEL_SIZE + PAGE_SIZE)
 #define K_COPY_IMAGE_END \
-    (K_INITRD_START + REAL_INITRD_SIZE + MALLOC_AREA_SIZE)
+	(K_INITRD_START + REAL_INITRD_SIZE + MALLOC_AREA_SIZE)
 #define K_COPY_IMAGE_SIZE \
-    NEXT_PAGE(K_COPY_IMAGE_END - K_COPY_IMAGE_START)
+	NEXT_PAGE(K_COPY_IMAGE_END - K_COPY_IMAGE_START)
 
 void
 start_kernel(void)
@@ -400,7 +400,7 @@ start_kernel(void)
 		   uncompressed_image_start,
 		   KERNEL_SIZE);
 #endif
-        decompress_kernel((void *)uncompressed_image_start,
+	decompress_kernel((void *)uncompressed_image_start,
 			  (void *)V_DATA_START,
 			  KERNEL_SIZE, KERNEL_Z_SIZE);
 
-- 
1.9.1

