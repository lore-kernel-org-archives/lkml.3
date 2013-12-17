Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3LQGLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:11:39 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64901 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQGLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:11:38 -0500
X-AuditID: 9c93017e-b7c17ae000003961-36-52afeb186379
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 1/5] zram: remove old private project comment
Date: Tue, 17 Dec 2013 15:11:59 +0900
Message-Id: <1387260723-15817-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387260723-15817-1-git-send-email-minchan@kernel.org>
References: <1387260723-15817-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes old private compcache project address so
upcoming patches should be sent to LKML because we Linux kernel
community will take care.

Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/blockdev/zram.txt |    6 ------
 drivers/block/zram/Kconfig      |    1 -
 drivers/block/zram/zram_drv.c   |    1 -
 drivers/block/zram/zram_drv.h   |    1 -
 4 files changed, 9 deletions(-)

diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 765d790ae831..2eccddffa6c8 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -1,8 +1,6 @@
 zram: Compressed RAM based block devices
 ----------------------------------------
 
-Project home: http://compcache.googlecode.com/
-
 * Introduction
 
 The zram module creates RAM based block devices named /dev/zram<id>
@@ -69,9 +67,5 @@ Following shows a typical sequence of steps for using zram.
 	resets the disksize to zero. You must set the disksize again
 	before reusing the device.
 
-Please report any problems at:
- - Mailing list: linux-mm-cc at laptop dot org
- - Issue tracker: http://code.google.com/p/compcache/issues/list
-
 Nitin Gupta
 ngupta@vflare.org
diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 983314c41349..3450be850399 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -14,7 +14,6 @@ config ZRAM
 	  disks and maybe many more.
 
 	  See zram.txt for more information.
-	  Project home: <https://compcache.googlecode.com/>
 
 config ZRAM_DEBUG
 	bool "Compressed RAM block device debug support"
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 108f2733106d..134d605836ca 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -9,7 +9,6 @@
  * Released under the terms of 3-clause BSD License
  * Released under the terms of GNU General Public License Version 2.0
  *
- * Project home: http://compcache.googlecode.com
  */
 
 #define KMSG_COMPONENT "zram"
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index d8f6596513c3..92f70e8f457c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -9,7 +9,6 @@
  * Released under the terms of 3-clause BSD License
  * Released under the terms of GNU General Public License Version 2.0
  *
- * Project home: http://compcache.googlecode.com
  */
 
 #ifndef _ZRAM_DRV_H_
-- 
1.7.9.5

