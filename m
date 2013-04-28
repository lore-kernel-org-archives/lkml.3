Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3D1LRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 07:17:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:35429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab3D1LRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 07:17:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,566,1363158000"; 
   d="scan'208";a="329014994"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 2/2] f2fs: remove useless #include <linux/proc_fs.h> as we're now using sysfs as debug entry.
Date: Sun, 28 Apr 2013 19:16:07 +0800
Message-Id: <1367147767-22155-2-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367147767-22155-1-git-send-email-haicheng.li@linux.intel.com>
References: <1367147767-22155-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/debug.c |    1 -
 fs/f2fs/gc.c    |    1 -
 fs/f2fs/super.c |    1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 025b9e2..08c9ce3 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -13,7 +13,6 @@
 
 #include <linux/fs.h>
 #include <linux/backing-dev.h>
-#include <linux/proc_fs.h>
 #include <linux/f2fs_fs.h>
 #include <linux/blkdev.h>
 #include <linux/debugfs.h>
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 94b8a0c..80d2747 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -11,7 +11,6 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
-#include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/f2fs_fs.h>
 #include <linux/kthread.h>
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index fea6e58..660e922 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/statfs.h>
-#include <linux/proc_fs.h>
 #include <linux/buffer_head.h>
 #include <linux/backing-dev.h>
 #include <linux/kthread.h>
-- 
1.7.9.5

