Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaHaPgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 11:36:53 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50814 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHaPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 11:36:52 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>, Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH] staging: dgnc: remove some unused macros
Date: Mon,  1 Sep 2014 00:36:39 +0900
Message-Id: <1409499399-4512-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros do nothing, so remove it.

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index 1111020..7776874 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -54,9 +54,9 @@
 #define	DEVSTR		"/dev/dg/dgnc"		/* /dev entries		 */
 #define	DRVSTR		"dgnc"			/* Driver name string
 						 * displayed by APR	 */
-#define	APR(args)	do { PRINTF_TO_KMEM(args); printk(DRVSTR": "); printk args; \
+#define	APR(args)	do { printk(DRVSTR": "); printk args; \
 			   } while (0)
-#define	RAPR(args)	do { PRINTF_TO_KMEM(args); printk args; } while (0)
+#define	RAPR(args)	do { printk args; } while (0)
 
 #define TRC_TO_CONSOLE 1
 
@@ -89,9 +89,6 @@
 
 #define	DBG_CARR		(dgnc_debug & 0x10000)
 
-#define PRINTF_TO_KMEM(args)
-# define TRC(ARGS)
-
 /* Number of boards we support at once. */
 #define	MAXBOARDS	20
 #define	MAXPORTS	8
-- 
1.7.9.5

