Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaIVXq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:46:56 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:44068 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIVXqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:46:54 -0400
From: Tommy Kurby <tommykurby91@gmail.com>
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tommy Kurby <tommykurby91@gmail.com>
Subject: [PATCH] Fs: Ext2: xip.h: fixed coding style issues
Date: Tue, 23 Sep 2014 01:46:40 +0200
Message-Id: <1411429600-4148-1-git-send-email-tommykurby91@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Tommy Kurby <tommykurby91@gmail.com>
---
 fs/ext2/xip.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
index 18b34d2..57b479b 100644
--- a/fs/ext2/xip.h
+++ b/fs/ext2/xip.h
@@ -6,12 +6,13 @@
  */
 
 #ifdef CONFIG_EXT2_FS_XIP
-extern void ext2_xip_verify_sb (struct super_block *);
-extern int ext2_clear_xip_target (struct inode *, sector_t);
+extern void ext2_xip_verify_sb(struct super_block *);
+extern int ext2_clear_xip_target(struct inode *, sector_t);
 
-static inline int ext2_use_xip (struct super_block *sb)
+static inline int ext2_use_xip(struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
+
 	return (sbi->s_mount_opt & EXT2_MOUNT_XIP);
 }
 int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
-- 
2.1.0

