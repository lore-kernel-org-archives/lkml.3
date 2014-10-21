Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaJUPAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:00:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62097 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaJUPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:00:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, corbet@lwn.net, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] treewide: Fix typo in Documentation/DocBook/device-drivers
Date: Wed, 22 Oct 2014 00:00:14 +0900
Message-Id: <1413903614-20775-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix speeling typo found in html files within
Documentation/DocBook/device-drivers.
It is because html files are generated from comments in source,
so I have to fix comments in the source.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/dma-buf/fence.c | 2 +-
 include/linux/fence.h   | 4 ++--
 include/linux/i2c.h     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
index 7bb9d65..e554111 100644
--- a/drivers/dma-buf/fence.c
+++ b/drivers/dma-buf/fence.c
@@ -283,7 +283,7 @@ EXPORT_SYMBOL(fence_add_callback);
  * @cb:		[in]	the callback to remove
  *
  * Remove a previously queued callback from the fence. This function returns
- * true if the callback is succesfully removed, or false if the fence has
+ * true if the callback is successfully removed, or false if the fence has
  * already been signaled.
  *
  * *WARNING*:
diff --git a/include/linux/fence.h b/include/linux/fence.h
index d174585..39efee1 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -128,8 +128,8 @@ struct fence_cb {
  * from irq context, so normal spinlocks can be used.
  *
  * A return value of false indicates the fence already passed,
- * or some failure occured that made it impossible to enable
- * signaling. True indicates succesful enabling.
+ * or some failure occurred that made it impossible to enable
+ * signaling. True indicates successful enabling.
  *
  * fence->status may be set in enable_signaling, but only when false is
  * returned.
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index b556e0a..70ee0d3 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -359,7 +359,7 @@ i2c_register_board_info(int busnum, struct i2c_board_info const *info,
  * to name two of the most common.
  *
  * The return codes from the @master_xfer field should indicate the type of
- * error code that occured during the transfer, as documented in the kernel
+ * error code that occurred during the transfer, as documented in the kernel
  * Documentation file Documentation/i2c/fault-codes.
  */
 struct i2c_algorithm {
-- 
2.1.2.451.g98349e5

