Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3DFFpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:45:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45430 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3DFFpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:45:04 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] f2fs: fix typo mistakes
Date: Sat,  6 Apr 2013 14:44:32 +0900
Message-Id: <1365227072-15321-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Fix typo mistakes.
1. I think that it should be 'L' instead of 'V'.
2. and try to fix 'Front' instead of 'Frone'

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/data.c    |    2 +-
 fs/f2fs/segment.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9ed6500..76ff48b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -136,7 +136,7 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 		goto end_update;
 	}
 
-	/* Frone merge */
+	/* Front merge */
 	if (fofs == start_fofs - 1 && blk_addr == start_blkaddr - 1) {
 		fi->ext.fofs--;
 		fi->ext.blk_addr--;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 4c2cd9e..aac74cd 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -11,7 +11,7 @@
 /* constant macro */
 #define NULL_SEGNO			((unsigned int)(~0))
 
-/* V: Logical segment # in volume, R: Relative segment # in main area */
+/* L: Logical segment # in volume, R: Relative segment # in main area */
 #define GET_L2R_SEGNO(free_i, segno)	(segno - free_i->start_segno)
 #define GET_R2L_SEGNO(free_i, segno)	(segno + free_i->start_segno)
 
-- 
1.7.9.5

