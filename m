Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3CRXDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:03:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55910 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3CRXDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:03:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, jaegeuk.kim@samsung.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] f2fs: Fix typo in comments
Date: Tue, 19 Mar 2013 08:03:35 +0900
Message-Id: <1363647815-5249-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in comments

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/f2fs/f2fs.h  | 2 +-
 fs/f2fs/gc.c    | 2 +-
 fs/f2fs/super.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cc2213a..201c8d3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -137,7 +137,7 @@ struct extent_info {
 	rwlock_t ext_lock;	/* rwlock for consistency */
 	unsigned int fofs;	/* start offset in a file */
 	u32 blk_addr;		/* start block address of the extent */
-	unsigned int len;	/* lenth of the extent */
+	unsigned int len;	/* length of the extent */
 };
 
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 94b8a0c..2e3eb2d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -222,7 +222,7 @@ static unsigned int get_gc_cost(struct f2fs_sb_info *sbi, unsigned int segno,
 }
 
 /*
- * This function is called from two pathes.
+ * This function is called from two paths.
  * One is garbage collection and the other is SSR segment selection.
  * When it is called during GC, it just gets a victim segment
  * and it does not remove it from dirty seglist.
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index fea6e58..62e0177 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -82,7 +82,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 
 	init_once((void *) fi);
 
-	/* Initilize f2fs-specific inode info */
+	/* Initialize f2fs-specific inode info */
 	fi->vfs_inode.i_version = 1;
 	atomic_set(&fi->dirty_dents, 0);
 	fi->i_current_depth = 1;
-- 
1.8.2

