Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaHUUqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:46:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:56927 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbaHUUqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:46:39 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: remove rename and use rename2
Date: Thu, 21 Aug 2014 13:46:39 -0700
Message-Id: <1408653999-86902-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refer the following patch.

commit 7177a9c4b509eb357cc450256bc3cf39f1a1e639
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Wed Jul 23 15:15:30 2014 +0200

    fs: call rename2 if exists

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index eb407d2..6b53ce9 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -704,7 +704,6 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.mkdir		= f2fs_mkdir,
 	.rmdir		= f2fs_rmdir,
 	.mknod		= f2fs_mknod,
-	.rename		= f2fs_rename,
 	.rename2	= f2fs_rename2,
 	.tmpfile	= f2fs_tmpfile,
 	.getattr	= f2fs_getattr,
-- 
1.8.5.2 (Apple Git-48)

