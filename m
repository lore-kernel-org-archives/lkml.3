Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbaFLL2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:28:11 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:41670 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbaFLL2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:28:08 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, sachin.kamat@linaro.org, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Subject: [PATCH] staging: lustre: obdclass: linux-sysctl.c: fix pointer coding style issue
Date: Thu, 12 Jun 2014 19:27:12 +0400
Message-Id: <1402586832-16481-1-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index c1ef0c9..b87ca10 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -196,7 +196,7 @@ int LL_PROC_PROTO(proc_max_dirty_pages_in_mb)
 	}
 	if (write) {
 		rc = lprocfs_write_frac_helper(buffer, *lenp,
-					       (unsigned int*)table->data,
+					       (unsigned int *)table->data,
 					       1 << (20 - PAGE_CACHE_SHIFT));
 		/* Don't allow them to let dirty pages exceed 90% of system
 		 * memory and set a hard minimum of 4MB. */
@@ -214,7 +214,7 @@ int LL_PROC_PROTO(proc_max_dirty_pages_in_mb)
 		int len;
 
 		len = lprocfs_read_frac_helper(buf, sizeof(buf),
-					       *(unsigned int*)table->data,
+					       *(unsigned int *)table->data,
 					       1 << (20 - PAGE_CACHE_SHIFT));
 		if (len > *lenp)
 			len = *lenp;
@@ -238,15 +238,14 @@ int LL_PROC_PROTO(proc_alloc_fail_rate)
 	}
 	if (write) {
 		rc = lprocfs_write_frac_helper(buffer, *lenp,
-					       (unsigned int*)table->data,
+					       (unsigned int *)table->data,
 					       OBD_ALLOC_FAIL_MULT);
 	} else {
 		char buf[21];
 		int  len;
 
 		len = lprocfs_read_frac_helper(buf, 21,
-					       *(unsigned int*)table->data,
+					       *(unsigned int *)table->data,
 					       OBD_ALLOC_FAIL_MULT);
 		if (len > *lenp)
 			len = *lenp;
--
1.7.10.4

