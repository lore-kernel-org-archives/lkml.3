Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbaGRFy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:54:28 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52511 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaGRFy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:54:27 -0400
From: Jim Richardson <weaselkeeper@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Jim Richardson <weaselkeeper@gmail.com>
Subject: [PATCH] block:bio.c Cleanup styleguide errors reported by checkpatch.pl
Date: Thu, 17 Jul 2014 22:54:11 -0700
Message-Id: <1405662851-25419-1-git-send-email-weaselkeeper@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 styleguide errors cleaned up from checkpatch.pl report for block/bio.c

Signed-off-by: Jim Richardson <weaselkeeper@gmail.com>
---
 block/bio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0ec61c9..41707f0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1337,7 +1337,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
 			if (len <= 0)
 				break;
-			
+
 			if (bytes > len)
 				bytes = len;
 
@@ -1374,7 +1374,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
  out_unmap:
 	for (i = 0; i < nr_pages; i++) {
-		if(!pages[i])
+		if (!pages[i])
 			break;
 		page_cache_release(pages[i]);
 	}
@@ -2025,7 +2025,7 @@ static void __init biovec_init_slabs(void)
 
 		size = bvs->nr_vecs * sizeof(struct bio_vec);
 		bvs->slab = kmem_cache_create(bvs->name, size, 0,
-                                SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 	}
 }
 
-- 
2.0.1

