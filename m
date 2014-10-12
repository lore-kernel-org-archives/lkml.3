Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaJLUqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:46:37 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:53788 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbaJLUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:46:29 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 3/5] fs/anon_inodes.c: Mark anon_inode_inode __read_mostly
Date: Sun, 12 Oct 2014 15:42:40 -0500
Message-Id: <1413146562-18147-3-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
References: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least, for consistency with anon_inode_mnt.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/anon_inodes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 268153a..444a705 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -23,7 +23,7 @@
 #include <asm/uaccess.h>
 
 static struct vfsmount *anon_inode_mnt __read_mostly;
-static struct inode *anon_inode_inode;
+static struct inode *anon_inode_inode __read_mostly;
 
 /*
  * anon_inodefs_dname() is called from d_path().
-- 
2.1.2

