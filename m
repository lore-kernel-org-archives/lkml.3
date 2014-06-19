Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbaFSHYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:24:17 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:64211 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbaFSHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:24:14 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, bergwolf@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Subject: [PATCHv2 1/3] staging: lustre: obdclass: linux-sysctl.c: fix pointer coding style issue
Date: Thu, 19 Jun 2014 11:24:11 +0400
Message-Id: <1403162653-17845-3-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403162653-17845-2-git-send-email-Andrej.Skvortzov@gmail.com>
References: <20140618223533.GA5096@kroah.com>
 <1403162653-17845-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <1403162653-17845-2-git-send-email-Andrej.Skvortzov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Skvortsov <skvortsov.av@summatechnology.ru>


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
@@ -238,14 +238,14 @@ int LL_PROC_PROTO(proc_alloc_fail_rate)
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

