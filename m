Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaIANQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:16:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59614 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaIANQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:16:17 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] ext4: fix comments about get_blocks
Date: Mon,  1 Sep 2014 22:16:02 +0900
Message-Id: <1409577362-4045-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_blocks is renamed to get_block.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9..6c91fb3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -590,7 +590,7 @@ found:
 	/*
 	 * New blocks allocate and/or writing to unwritten extent
 	 * will possibly result in updating i_data, so we take
-	 * the write lock of i_data_sem, and call get_blocks()
+	 * the write lock of i_data_sem, and call get_block()
 	 * with create == 1 flag.
 	 */
 	down_write(&EXT4_I(inode)->i_data_sem);
@@ -1536,7 +1536,7 @@ out_unlock:
 }
 
 /*
- * This is a special get_blocks_t callback which is used by
+ * This is a special get_block_t callback which is used by
  * ext4_da_write_begin().  It will either return mapped block or
  * reserve space for a single block.
  *
-- 
1.7.9.5

