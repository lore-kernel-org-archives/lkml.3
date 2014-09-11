Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaIKM3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:29:24 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47791 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbaIKM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 3/9] drbd: Remove superfluous newline from "resync_extents" debugfs entry.
Date: Thu, 11 Sep 2014 14:29:07 +0200
Message-Id: <1410438553-30440-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Marek <philipp.marek@linbit.com>

See "drbd/resources/*/volumes/*/resync_extents".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index 5c20b18..900d4d3 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -695,7 +695,7 @@ static void resync_dump_detail(struct seq_file *m, struct lc_element *e)
 {
        struct bm_extent *bme = lc_entry(e, struct bm_extent, lce);
 
-       seq_printf(m, "%5d %s %s %s\n", bme->rs_left,
+       seq_printf(m, "%5d %s %s %s", bme->rs_left,
 		  test_bit(BME_NO_WRITES, &bme->flags) ? "NO_WRITES" : "---------",
 		  test_bit(BME_LOCKED, &bme->flags) ? "LOCKED" : "------",
 		  test_bit(BME_PRIORITY, &bme->flags) ? "PRIORITY" : "--------"
-- 
1.9.1

