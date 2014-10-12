Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaJLTdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:33:04 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47744 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:33:00 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] fs/file_table.c: Update alloc_file() comment
Date: Sun, 12 Oct 2014 14:29:29 -0500
Message-Id: <1413142169-6721-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment is 5 years outdated; init_file() no longer exists.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/file_table.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 0bab12b..3f85411 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -150,18 +150,10 @@ over:
 
 /**
  * alloc_file - allocate and initialize a 'struct file'
- * @mnt: the vfsmount on which the file will reside
- * @dentry: the dentry representing the new file
+ *
+ * @path: the (dentry, vfsmount) pair for the new file
  * @mode: the mode with which the new file will be opened
  * @fop: the 'struct file_operations' for the new file
- *
- * Use this instead of get_empty_filp() to get a new
- * 'struct file'.  Do so because of the same initialization
- * pitfalls reasons listed for init_file().  This is a
- * preferred interface to using init_file().
- *
- * If all the callers of init_file() are eliminated, its
- * code should be moved into this function.
  */
 struct file *alloc_file(struct path *path, fmode_t mode,
 		const struct file_operations *fop)
-- 
2.1.2

