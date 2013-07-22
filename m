Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3GVQOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:14:52 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51857 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab3GVQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:33 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Keith Mannthey <keith.mannthey@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 45/48] staging/lustre/style: removes obsolete EXPORT_SYMTAB macros v2
Date: Tue, 23 Jul 2013 00:07:06 +0800
Message-Id: <1374509230-3324-46-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Mannthey <keith.mannthey@intel.com>

EXPORT_SYMTAB is obsolete after 2.4 kernel, this patch removes
EXPORT_SYMTAB from the source code again.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1347
Lustre-change: http://review.whamcloud.com/6739
Signed-off-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Peng Tao <bergwolf@gmail.com>
Reviewed-by: Liu Xuezhao <xuezhao.liu@emc.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |    3 ---
 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c |    3 ---
 drivers/staging/lustre/lustre/libcfs/libcfs_mem.c  |    3 ---
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  |    4 ----
 4 files changed, 13 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c b/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
index 8e88eb5..1fb3700 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c
@@ -33,9 +33,6 @@
  * Author: liang@whamcloud.com
  */
 
-#ifndef EXPORT_SYMTAB
-# define EXPORT_SYMTAB
-#endif
 #define DEBUG_SUBSYSTEM S_LNET
 
 #include <linux/libcfs/libcfs.h>
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c b/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
index 8d6c4ad..a2ce4c0 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
@@ -30,9 +30,6 @@
  * Author: liang@whamcloud.com
  */
 
-#ifndef EXPORT_SYMTAB
-# define EXPORT_SYMTAB
-#endif
 #define DEBUG_SUBSYSTEM S_LNET
 
 #include <linux/libcfs/libcfs.h>
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_mem.c b/drivers/staging/lustre/lustre/libcfs/libcfs_mem.c
index 8791373..feab537 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_mem.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_mem.c
@@ -31,9 +31,6 @@
  * Author: liang@whamcloud.com
  */
 
-#ifndef EXPORT_SYMTAB
-# define EXPORT_SYMTAB
-#endif
 #define DEBUG_SUBSYSTEM S_LNET
 
 #include <linux/libcfs/libcfs.h>
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_osd.c b/drivers/staging/lustre/lustre/obdclass/llog_osd.c
index 6dbd21a..87d5012 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_osd.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_osd.c
@@ -41,10 +41,6 @@
 
 #define DEBUG_SUBSYSTEM S_LOG
 
-#ifndef EXPORT_SYMTAB
-#define EXPORT_SYMTAB
-#endif
-
 #include <obd.h>
 #include <obd_class.h>
 #include <lustre_fid.h>
-- 
1.7.9.5

