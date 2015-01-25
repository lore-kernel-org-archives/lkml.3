Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbbAYRD2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:03:28 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52838 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbbAYRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:03:25 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Martin Mares <mj@ucw.cz>, Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot: remove pointless comments
Date: Sun, 25 Jan 2015 23:03:15 +0600
Message-Id: <1422205395-6027-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1.275.g028c360
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove old comments that include the old arch/i386 directory.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/compressed/head_32.S | 4 ----
 arch/x86/boot/compressed/head_64.S | 8 +++-----
 arch/x86/boot/compressed/misc.c    | 2 --
 arch/x86/boot/header.S             | 2 --
 arch/x86/boot/video-mode.c         | 2 --
 5 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1d7fbbc..59d1497 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -1,12 +1,8 @@
 /*
- *  linux/boot/head.S
- *
  *  Copyright (C) 1991, 1992, 1993  Linus Torvalds
  */
 
 /*
- *  head.S contains the 32-bit startup code.
- *
  * NOTE!!! Startup happens at absolute address 0x00001000, which is also where
  * the page directory will exist. The startup code will be overwritten by
  * the page directory. [According to comments etc elsewhere on a compressed
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 6b1766c..df31949 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -5,16 +5,14 @@
  */
 
 /*
- *  head.S contains the 32-bit startup code.
- *
  * NOTE!!! Startup happens at absolute address 0x00001000, which is also where
  * the page directory will exist. The startup code will be overwritten by
  * the page directory. [According to comments etc elsewhere on a compressed
  * kernel it will end up at 0x1000 + 1Mb I hope so as I assume this. - AC]
  *
- * Page 0 is deliberately kept safe, since System Management Mode code in 
+ * Page 0 is deliberately kept safe, since System Management Mode code in
  * laptops may need to access the BIOS data stored there.  This is also
- * useful for future device drivers that either access the BIOS via VM86 
+ * useful for future device drivers that either access the BIOS via VM86
  * mode.
  */
 
@@ -397,7 +395,7 @@ relocated:
 	addq	$8, %rdx
 	jmp	1b
 2:
-	
+
 /*
  * Do the decompression, and jump to the new kernel..
  */
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dcc1c53..d56f106 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -1,6 +1,4 @@
 /*
- * misc.c
- *
  * This is a collection of several routines from gzip-1.0.3
  * adapted for Linux.
  *
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 16ef025..fe3ffb4 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -1,6 +1,4 @@
 /*
- *	header.S
- *
  *	Copyright (C) 1991, 1992 Linus Torvalds
  *
  *	Based on bootsect.S and setup.S
diff --git a/arch/x86/boot/video-mode.c b/arch/x86/boot/video-mode.c
index 748e8d0..4f4a8ee 100644
--- a/arch/x86/boot/video-mode.c
+++ b/arch/x86/boot/video-mode.c
@@ -9,8 +9,6 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * arch/i386/boot/video-mode.c
- *
  * Set the video mode.  This is separated out into a different
  * file in order to be shared with the ACPI wakeup code.
  */
-- 
2.3.0.rc1.275.g028c360

