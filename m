Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaJLUqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:46:35 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54652 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaJLUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:46:31 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 4/5] fs/anon_inodes.c: Remove unneeded #includes
Date: Sun, 12 Oct 2014 15:42:41 -0500
Message-Id: <1413146562-18147-4-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
References: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/anon_inodes.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 444a705..bbfa038 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -8,10 +8,7 @@
  *
  */
 
-#include <linux/cred.h>
 #include <linux/file.h>
-#include <linux/poll.h>
-#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -20,8 +17,6 @@
 #include <linux/magic.h>
 #include <linux/anon_inodes.h>
 
-#include <asm/uaccess.h>
-
 static struct vfsmount *anon_inode_mnt __read_mostly;
 static struct inode *anon_inode_inode __read_mostly;
 
-- 
2.1.2

