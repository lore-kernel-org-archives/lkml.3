Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab3CTPKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:10:11 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52190 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3CTPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:10:09 -0400
From: Alice Ferrazzi <alice.ferrazzi@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alice Ferrazzi <alice.ferrazzi@gmail.com>
Subject: [PATCH] Block: blk-flush: Fixed indent code style
Date: Thu, 21 Mar 2013 00:09:59 +0900
Message-Id: <1363792199-14066-1-git-send-email-alice.ferrazzi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code indent should use tabs where possible.

Signed-off-by: Alice Ferrazzi <alice.ferrazzi@gmail.com>
---
 block/blk-flush.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index db8f1b5..cc2b827 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -444,7 +444,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	 * copied from blk_rq_pos(rq).
 	 */
 	if (error_sector)
-               *error_sector = bio->bi_sector;
+		*error_sector = bio->bi_sector;
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
-- 
1.7.10.4

