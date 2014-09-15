Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaIOPGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:06:25 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:34346 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaIOPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:06:24 -0400
Date: Mon, 15 Sep 2014 17:06:19 +0200
From: Michele Curti <michele.curti@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: [PATCH] blkdev: use NULL instead of zero
Message-ID: <20140915150619.GA11016@powerline.azcom-win.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


blkdev: use NULL instead of zero

Signed-off-by: Michele Curti <michele.curti@gmail.com>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3a7449d..66c8298 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1533,7 +1533,7 @@ static inline int blk_rq_map_integrity_sg(struct request_queue *q,
 }
 static inline struct blk_integrity *bdev_get_integrity(struct block_device *b)
 {
-	return 0;
+	return NULL;
 }
 static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 {
-- 
2.1.0

Quite useless but it shuts up some warnings.

Regards,
Michele

