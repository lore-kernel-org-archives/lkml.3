Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3FGJ4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:56:04 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:36937 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3FGJ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:56:02 -0400
From: Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
To: gregkh@linuxfoundation.org, devendra.aaru@gmail.com, plaes@plaes.org,
        dwa2pac@gmail.com, yongjun_wei@trendmicro.com.cn
Cc: devel@driverdev.osusl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: csr: fix indentation code style issue in csr_framework_ext.c
Date: Fri,  7 Jun 2013 09:54:51 +0000
Message-Id: <1370598891-8808-1-git-send-email-dwa2pac@gmail.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to csr_framework.c that fixes indentation style issues
found by the checkpatch.pl tool.

Signed-off-by: Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
---
 drivers/staging/csr/csr_framework_ext.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.c b/drivers/staging/csr/csr_framework_ext.c
index 2aabb6c..98122bc 100644
--- a/drivers/staging/csr/csr_framework_ext.c
+++ b/drivers/staging/csr/csr_framework_ext.c
@@ -1,10 +1,10 @@
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+		(c) Cambridge Silicon Radio Limited 2010
+		All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+		Refer to LICENSE.txt included with this source for details
+		on the license terms.
 
 *****************************************************************************/
 
@@ -31,10 +31,10 @@
  *----------------------------------------------------------------------------*/
 void CsrThreadSleep(u16 sleepTimeInMs)
 {
-    unsigned long t;
+	unsigned long t;
 
-    /* Convert t in ms to jiffies and round up */
-    t = ((sleepTimeInMs * HZ) + 999) / 1000;
-    schedule_timeout_uninterruptible(t);
+	/* Convert t in ms to jiffies and round up */
+	t = ((sleepTimeInMs * HZ) + 999) / 1000;
+	schedule_timeout_uninterruptible(t);
 }
 EXPORT_SYMBOL_GPL(CsrThreadSleep);
-- 
1.8.3

