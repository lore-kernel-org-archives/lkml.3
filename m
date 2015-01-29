Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbbA2L5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:57:42 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36722 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbbA2L4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:56:48 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] fs/btrfs: fix a typo in prev_extent_map banner comment
Date: Thu, 29 Jan 2015 17:56:35 +0600
Message-Id: <1422532595-11523-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8bf326a..ae9bf84 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6289,7 +6289,7 @@ static struct extent_map *prev_extent_map(struct extent_map *em)
 	return container_of(prev, struct extent_map, rb_node);
 }
 
-/* helper for btfs_get_extent.  Given an existing extent in the tree,
+/* helper for btrfs_get_extent.  Given an existing extent in the tree,
  * the existing extent is the nearest extent to map_start,
  * and an extent that you want to insert, deal with overlap and insert
  * the best fitted new extent into the tree.
-- 
2.3.0-rc1

