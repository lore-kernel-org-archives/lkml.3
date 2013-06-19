Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261Ab3FSDR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:17:56 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:36314 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934127Ab3FSDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:17:54 -0400
From: "John B. Wyatt IV" <sageofredondo@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John B. Wyatt IV" <sageofredondo@gmail.com>
Subject: [PATCH] Acpi: acpica: acmacros: fixed a semicolon formatting issue.
Date: Tue, 18 Jun 2013 20:17:40 -0700
Message-Id: <1371611860-21056-1-git-send-email-sageofredondo@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John B. Wyatt IV" <sageofredondo@gmail.com>

Formatting patch: fixes all "space required after that ';'" errors in
acmarcos.h.

Please note this only fixes 12 out of 64 errors as reported by
./scripts/checkpatch.pl
---
 drivers/acpi/acpica/acmacros.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpica/acmacros.h b/drivers/acpi/acpica/acmacros.h
index 53666bd..b916eed 100644
--- a/drivers/acpi/acpica/acmacros.h
+++ b/drivers/acpi/acpica/acmacros.h
@@ -93,15 +93,15 @@
 /* 16-bit source, 16/32/64 destination */
 
 #define ACPI_MOVE_16_TO_16(d, s)        {((  u8 *)(void *)(d))[0] = ((u8 *)(void *)(s))[1];\
-			  ((  u8 *)(void *)(d))[1] = ((u8 *)(void *)(s))[0];}
+			  ((  u8 *)(void *)(d))[1] = ((u8 *)(void *)(s))[0]; }
 
 #define ACPI_MOVE_16_TO_32(d, s)        {(*(u32 *)(void *)(d))=0;\
 					  ((u8 *)(void *)(d))[2] = ((u8 *)(void *)(s))[1];\
-					  ((u8 *)(void *)(d))[3] = ((u8 *)(void *)(s))[0];}
+					  ((u8 *)(void *)(d))[3] = ((u8 *)(void *)(s))[0]; }
 
 #define ACPI_MOVE_16_TO_64(d, s)        {(*(u64 *)(void *)(d))=0;\
 							   ((u8 *)(void *)(d))[6] = ((u8 *)(void *)(s))[1];\
-							   ((u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[0];}
+							   ((u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[0]; }
 
 /* 32-bit source, 16/32/64 destination */
 
@@ -110,13 +110,13 @@
 #define ACPI_MOVE_32_TO_32(d, s)        {((  u8 *)(void *)(d))[0] = ((u8 *)(void *)(s))[3];\
 									  ((  u8 *)(void *)(d))[1] = ((u8 *)(void *)(s))[2];\
 									  ((  u8 *)(void *)(d))[2] = ((u8 *)(void *)(s))[1];\
-									  ((  u8 *)(void *)(d))[3] = ((u8 *)(void *)(s))[0];}
+									  ((  u8 *)(void *)(d))[3] = ((u8 *)(void *)(s))[0]; }
 
 #define ACPI_MOVE_32_TO_64(d, s)        {(*(u64 *)(void *)(d))=0;\
 										   ((u8 *)(void *)(d))[4] = ((u8 *)(void *)(s))[3];\
 										   ((u8 *)(void *)(d))[5] = ((u8 *)(void *)(s))[2];\
 										   ((u8 *)(void *)(d))[6] = ((u8 *)(void *)(s))[1];\
-										   ((u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[0];}
+										   ((u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[0]; }
 
 /* 64-bit source, 16/32/64 destination */
 
@@ -131,7 +131,7 @@
 										 ((  u8 *)(void *)(d))[4] = ((u8 *)(void *)(s))[3];\
 										 ((  u8 *)(void *)(d))[5] = ((u8 *)(void *)(s))[2];\
 										 ((  u8 *)(void *)(d))[6] = ((u8 *)(void *)(s))[1];\
-										 ((  u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[0];}
+										 ((  u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[0]; }
 #else
 /*
  * Macros for little-endian machines
@@ -169,10 +169,10 @@
 /* 16-bit source, 16/32/64 destination */
 
 #define ACPI_MOVE_16_TO_16(d, s)        {((  u8 *)(void *)(d))[0] = ((u8 *)(void *)(s))[0];\
-										 ((  u8 *)(void *)(d))[1] = ((u8 *)(void *)(s))[1];}
+										 ((  u8 *)(void *)(d))[1] = ((u8 *)(void *)(s))[1]; }
 
-#define ACPI_MOVE_16_TO_32(d, s)        {(*(u32 *)(void *)(d)) = 0; ACPI_MOVE_16_TO_16(d, s);}
-#define ACPI_MOVE_16_TO_64(d, s)        {(*(u64 *)(void *)(d)) = 0; ACPI_MOVE_16_TO_16(d, s);}
+#define ACPI_MOVE_16_TO_32(d, s)        {(*(u32 *)(void *)(d)) = 0; ACPI_MOVE_16_TO_16(d, s); }
+#define ACPI_MOVE_16_TO_64(d, s)        {(*(u64 *)(void *)(d)) = 0; ACPI_MOVE_16_TO_16(d, s); }
 
 /* 32-bit source, 16/32/64 destination */
 
@@ -181,9 +181,9 @@
 #define ACPI_MOVE_32_TO_32(d, s)        {((  u8 *)(void *)(d))[0] = ((u8 *)(void *)(s))[0];\
 										 ((  u8 *)(void *)(d))[1] = ((u8 *)(void *)(s))[1];\
 										 ((  u8 *)(void *)(d))[2] = ((u8 *)(void *)(s))[2];\
-										 ((  u8 *)(void *)(d))[3] = ((u8 *)(void *)(s))[3];}
+										 ((  u8 *)(void *)(d))[3] = ((u8 *)(void *)(s))[3]; }
 
-#define ACPI_MOVE_32_TO_64(d, s)        {(*(u64 *)(void *)(d)) = 0; ACPI_MOVE_32_TO_32(d, s);}
+#define ACPI_MOVE_32_TO_64(d, s)        {(*(u64 *)(void *)(d)) = 0; ACPI_MOVE_32_TO_32(d, s); }
 
 /* 64-bit source, 16/32/64 destination */
 
@@ -196,7 +196,7 @@
 										 ((  u8 *)(void *)(d))[4] = ((u8 *)(void *)(s))[4];\
 										 ((  u8 *)(void *)(d))[5] = ((u8 *)(void *)(s))[5];\
 										 ((  u8 *)(void *)(d))[6] = ((u8 *)(void *)(s))[6];\
-										 ((  u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[7];}
+										 ((  u8 *)(void *)(d))[7] = ((u8 *)(void *)(s))[7]; }
 #endif
 #endif
 
-- 
1.8.1.2

