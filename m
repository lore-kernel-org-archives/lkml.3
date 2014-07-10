Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaGJTA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:00:27 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:14831 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaGJTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:00:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgMAE7ivlNbsHe//2dsb2JhbABZgw6tIAUBAQEBAQEFAW6bPIEOF3WEYCOBAhg3iC4DFQG0EYt+DYcYF4V6hx+CKx2ELQWQEYhvggCOAYYUg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, logfs@logfs.org
Subject: [PATCH 1/1] fs/logfs/readwrite.c: kernel-doc warning fixes
Date: Thu, 10 Jul 2014 20:59:51 +0200
Message-Id: <1405018791-5467-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/-/: and fix variable names.

Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: logfs@logfs.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/logfs/readwrite.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 4814031..380d86e 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -1019,11 +1019,11 @@ static int __logfs_is_valid_block(struct inode *inode, u64 bix, u64 ofs)
 /**
  * logfs_is_valid_block - check whether this block is still valid
  *
- * @sb	- superblock
- * @ofs	- block physical offset
- * @ino	- block inode number
- * @bix	- block index
- * @level - block level
+ * @sb:		superblock
+ * @ofs:	block physical offset
+ * @ino:	block inode number
+ * @bix:	block index
+ * @gc_level:	block level
  *
  * Returns 0 if the block is invalid, 1 if it is valid and 2 if it will
  * become invalid once the journal is written.
@@ -2226,10 +2226,9 @@ void btree_write_block(struct logfs_block *block)
  *
  * @inode:		parent inode (ifile or directory)
  * @buf:		object to write (inode or dentry)
- * @n:			object size
- * @_pos:		object number (file position in blocks/objects)
+ * @count:		object size
+ * @bix:		block index
  * @flags:		write flags
- * @lock:		0 if write lock is already taken, 1 otherwise
  * @shadow_tree:	shadow below this inode
  *
  * FIXME: All caller of this put a 200-300 byte variable on the stack,
-- 
1.9.1

