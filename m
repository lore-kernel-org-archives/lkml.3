Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaLZMjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:39:31 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:49984 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaLZMj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:39:29 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86: Fix multiple coding style issues
Date: Fri, 26 Dec 2014 18:38:59 +0600
Message-Id: <1419597539-21254-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g98acd41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/header.S | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 16ef025..75f016b 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -211,7 +211,8 @@ section_table:
 	.long	0				# PointerToLineNumbers
 	.word	0				# NumberOfRelocations
 	.word	0				# NumberOfLineNumbers
-	.long	0x60500020			# Characteristics (section flags)
+	.long	0x60500020			# Characteristics
+						# (section flags)
 
 	#
 	# The EFI application loader requires a relocation section
@@ -229,7 +230,8 @@ section_table:
 	.long	0				# PointerToLineNumbers
 	.word	0				# NumberOfRelocations
 	.word	0				# NumberOfLineNumbers
-	.long	0x42100040			# Characteristics (section flags)
+	.long	0x42100040			# Characteristics
+						# (section flags)
 
 	#
 	# The offset & size fields are filled in by build.c.
@@ -247,7 +249,8 @@ section_table:
 	.long	0				# PointerToLineNumbers
 	.word	0				# NumberOfRelocations
 	.word	0				# NumberOfLineNumbers
-	.long	0x60500020			# Characteristics (section flags)
+	.long	0x60500020			# Characteristics
+						# (section flags)
 
 	#
 	# The offset & size fields are filled in by build.c.
@@ -266,7 +269,8 @@ section_table:
 	.long	0				# PointerToLineNumbers
 	.word	0				# NumberOfRelocations
 	.word	0				# NumberOfLineNumbers
-	.long	0xc8000080			# Characteristics (section flags)
+	.long	0xc8000080			# Characteristics
+						# (section flags)
 
 #endif /* CONFIG_EFI_STUB */
 
@@ -426,7 +430,8 @@ cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
                                                 #version 2.06
 
-hardware_subarch:	.long 0			# subarchitecture, added with 2.07
+hardware_subarch:	.long 0			# subarchitecture,
+						# added with 2.07
 						# default to 0 for normal x86 PC
 
 hardware_subarch_data:	.quad 0
-- 
2.2.1.202.g98acd41

