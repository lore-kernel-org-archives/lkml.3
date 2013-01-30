Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3A3Nrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:47:45 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43985 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3A3Nrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:47:40 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/3] f2fs: fix typo mistake for data_version description
Date: Wed, 30 Jan 2013 22:47:29 +0900
Message-Id: <1359553649-7517-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In f2fs_inode_info structure, the description for data_version
has a typo mistake. It should be latest instead of lastes.
So, correcting that.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/f2fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f4f5097..975cb44 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -141,7 +141,7 @@ struct f2fs_inode_info {
 
 	/* Use below internally in f2fs*/
 	unsigned long flags;		/* use to pass per-file flags */
-	unsigned long long data_version;/* lastes version of data for fsync */
+	unsigned long long data_version;/* latest version of data for fsync */
 	atomic_t dirty_dents;		/* # of dirty dentry pages */
 	f2fs_hash_t chash;		/* hash value of given file name */
 	unsigned int clevel;		/* maximum level of given file name */
-- 
1.7.9.5

