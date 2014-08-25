Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaHYN1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:27:08 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:56665 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbaHYNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:25:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 3/8] drbd: Remove superfluous newline from "resync_extents" debugfs entry.
Date: Mon, 25 Aug 2014 15:16:33 +0200
Message-Id: <1408972598-16650-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408972598-16650-1-git-send-email-philipp.reisner@linbit.com>
References: <1408972598-16650-1-git-send-email-philipp.reisner@linbit.com>
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

