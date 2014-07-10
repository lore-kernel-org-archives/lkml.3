Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaGJTJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:09:53 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:45382 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbaGJTJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:09:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgMACLkvlNbsHe//2dsb2JhbABZgw6tIAUBAQEBAQEFAW6bPIEOF3WEMS8jgRo3iC4DFQG0G4t/FYcQF4V6iHkBAU8dhC0FkBGKb5QVg0U7gTo
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ufs/inode.c: kernel-doc warning fixes.
Date: Thu, 10 Jul 2014 21:09:47 +0200
Message-Id: <1405019387-5546-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/inode.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 61e8a9b..7c580c9 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -158,16 +158,16 @@ out:
 
 /**
  * ufs_inode_getfrag() - allocate new fragment(s)
- * @inode - pointer to inode
- * @fragment - number of `fragment' which hold pointer
+ * @inode: pointer to inode
+ * @fragment: number of `fragment' which hold pointer
  *   to new allocated fragment(s)
- * @new_fragment - number of new allocated fragment(s)
- * @required - how many fragment(s) we require
- * @err - we set it if something wrong
- * @phys - pointer to where we save physical number of new allocated fragments,
+ * @new_fragment: number of new allocated fragment(s)
+ * @required: how many fragment(s) we require
+ * @err: we set it if something wrong
+ * @phys: pointer to where we save physical number of new allocated fragments,
  *   NULL if we allocate not data(indirect blocks for example).
- * @new - we set it if we allocate new block
- * @locked_page - for ufs_new_fragments()
+ * @new: we set it if we allocate new block
+ * @locked_page: for ufs_new_fragments()
  */
 static struct buffer_head *
 ufs_inode_getfrag(struct inode *inode, u64 fragment,
@@ -315,16 +315,16 @@ repeat2:
 
 /**
  * ufs_inode_getblock() - allocate new block
- * @inode - pointer to inode
- * @bh - pointer to block which hold "pointer" to new allocated block
- * @fragment - number of `fragment' which hold pointer
+ * @inode: pointer to inode
+ * @bh: pointer to block which hold "pointer" to new allocated block
+ * @fragment: number of `fragment' which hold pointer
  *   to new allocated block
- * @new_fragment - number of new allocated fragment
+ * @new_fragment: number of new allocated fragment
  *  (block will hold this fragment and also uspi->s_fpb-1)
- * @err - see ufs_inode_getfrag()
- * @phys - see ufs_inode_getfrag()
- * @new - see ufs_inode_getfrag()
- * @locked_page - see ufs_inode_getfrag()
+ * @err: see ufs_inode_getfrag()
+ * @phys: see ufs_inode_getfrag()
+ * @new: see ufs_inode_getfrag()
+ * @locked_page: see ufs_inode_getfrag()
  */
 static struct buffer_head *
 ufs_inode_getblock(struct inode *inode, struct buffer_head *bh,
-- 
1.9.1

