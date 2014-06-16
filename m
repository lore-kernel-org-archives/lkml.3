Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaFPSbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:31:12 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:6359 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932496AbaFPSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:31:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYQxLyOBGjeIRgHPQYVjiRMdhC0Ej2yKV5NYg0I7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] fs/romfs/super.c: add blank line after declarations.
Date: Mon, 16 Jun 2014 20:29:52 +0200
Message-Id: <1402943392-10836-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
"WARNING: Missing a blank line after declarations"

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/romfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 6e73879..e98dd88 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -392,6 +392,7 @@ error:
 static struct inode *romfs_alloc_inode(struct super_block *sb)
 {
 	struct romfs_inode_info *inode;
+
 	inode = kmem_cache_alloc(romfs_inode_cachep, GFP_KERNEL);
 	return inode ? &inode->vfs_inode : NULL;
 }
@@ -402,6 +403,7 @@ static struct inode *romfs_alloc_inode(struct super_block *sb)
 static void romfs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
+
 	kmem_cache_free(romfs_inode_cachep, ROMFS_I(inode));
 }
 
-- 
1.8.4.5

