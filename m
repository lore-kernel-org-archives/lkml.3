Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3HHSXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:23:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48089 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3HHSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:23:44 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: gregkh@linuxfoundation.org, minchan@kernel.org, jiang.liu@huawei.com,
        ngupta@vflare.org, jmarchan@redhat.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kumargauravgupta3@gmail.com
Subject: [PATCH] Staging:zram:zram_drv.c Fixed Error of trailing whitespace
Date: Thu,  8 Aug 2013 23:53:24 +0530
Message-Id: <1375986205-5912-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed by removing trailing whitespace

Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 82c7202..f590715 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -169,7 +169,7 @@ static inline int is_partial_io(struct bio_vec *bvec)
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
 	u64 start, end, bound;
-	
+
 	/* unaligned request */
 	if (unlikely(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
 		return 0;
-- 
1.7.9.5

