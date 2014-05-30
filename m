Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbaE3XLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 19:11:24 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39558 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaE3XLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 19:11:22 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org, Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH] drivers/w1/w1_int.c: Fix style errors.
Date: Fri, 30 May 2014 16:10:20 -0700
Message-Id: <1401491420-6953-1-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace spaces at beginning of the string with tabs, and replace foo * bar with foo *bar in a pointer declaration.

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---
This time using linux-next!

 drivers/w1/w1_int.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index ec3fc93..3c26a58 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -38,7 +38,7 @@ module_param_named(search_count, w1_search_count, int, 0);
 static int w1_enable_pullup = 1;
 module_param_named(enable_pullup, w1_enable_pullup, int, 0);
 
-static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
+static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 				       struct device_driver *driver,
 				       struct device *device)
 {
@@ -115,13 +115,13 @@ int w1_add_master_device(struct w1_bus_master *master)
 	struct w1_netlink_msg msg;
 	int id, found;
 
-        /* validate minimum functionality */
-        if (!(master->touch_bit && master->reset_bus) &&
-            !(master->write_bit && master->read_bit) &&
+	/* validate minimum functionality */
+	if (!(master->touch_bit && master->reset_bus) &&
+	    !(master->write_bit && master->read_bit) &&
 	    !(master->write_byte && master->read_byte && master->reset_bus)) {
 		printk(KERN_ERR "w1_add_master_device: invalid function set\n");
 		return(-EINVAL);
-        }
+	}
 
 	/* Lock until the device is added (or not) to w1_masters. */
 	mutex_lock(&w1_mlock);
-- 
1.9.1

