Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaLSOen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:34:43 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61098 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaLSOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:34:42 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: dwmw2@infradead.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH] mtd: ssfdc: Fix space before ( coding style
Date: Fri, 19 Dec 2014 20:00:13 +0530
Message-Id: <1418999413-29428-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch solves the space before ( coding style issue of ssfdc.c

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 drivers/mtd/ssfdc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
index daf82ba..d4a922c 100644
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -42,8 +42,8 @@ struct ssfdcr_record {
 #define MAX_LOGIC_BLK_PER_ZONE	1000
 #define MAX_PHYS_BLK_PER_ZONE	1024
 
-#define KiB(x)	( (x) * 1024L )
-#define MiB(x)	( KiB(x) * 1024L )
+#define KiB(x)	((x) * 1024L)
+#define MiB(x)	(KiB(x) * 1024L)
 
 /** CHS Table
 		1MiB	2MiB	4MiB	8MiB	16MiB	32MiB	64MiB	128MiB
@@ -63,13 +63,13 @@ typedef struct {
 
 /* Must be ordered by size */
 static const chs_entry_t chs_table[] = {
-	{ MiB(  1), 125,  4,  4 },
-	{ MiB(  2), 125,  4,  8 },
-	{ MiB(  4), 250,  4,  8 },
-	{ MiB(  8), 250,  4, 16 },
-	{ MiB( 16), 500,  4, 16 },
-	{ MiB( 32), 500,  8, 16 },
-	{ MiB( 64), 500,  8, 32 },
+	{ MiB(1), 125,  4,  4 },
+	{ MiB(2), 125,  4,  8 },
+	{ MiB(4), 250,  4,  8 },
+	{ MiB(8), 250,  4, 16 },
+	{ MiB(16), 500,  4, 16 },
+	{ MiB(32), 500,  8, 16 },
+	{ MiB(64), 500,  8, 32 },
 	{ MiB(128), 500, 16, 32 },
 	{ 0 },
 };
-- 
1.7.9.5

