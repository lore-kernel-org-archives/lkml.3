Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbaJaGQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:16:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:44089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759978AbaJaGQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:16:16 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/4] f2fs: remove unnecessary macro
Date: Thu, 30 Oct 2014 23:16:15 -0700
Message-Id: <1414736176-13201-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414736176-13201-1-git-send-email-jaegeuk@kernel.org>
References: <1414736176-13201-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's remove unused macro.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 include/linux/f2fs_fs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index cc1064f..87f14e9 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -177,10 +177,6 @@ struct f2fs_extent {
 #define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
 						F2FS_INLINE_XATTR_ADDRS - 1))
 
-#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) -\
-				sizeof(__le32) * (DEF_ADDRS_PER_INODE + \
-				DEF_NIDS_PER_INODE - 1))
-
 struct f2fs_inode {
 	__le16 i_mode;			/* file mode */
 	__u8 i_advise;			/* file hints */
-- 
2.1.1

