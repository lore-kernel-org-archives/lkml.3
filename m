Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaJKSce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:32:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33042 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaJKScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:32:33 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] char: misc: fix coding style issues
Date: Sun, 12 Oct 2014 00:02:19 +0530
Message-Id: <1413052339-2702-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl error
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index a6b96b1..47c9b04 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -144,7 +144,7 @@ static int misc_open(struct inode *inode, struct file *file)
 	replace_fops(file, new_fops);
 	if (file->f_op->open) {
 		file->private_data = c;
-		err = file->f_op->open(inode,file);
+		err = file->f_op->open(inode, file);
 	}
 fail:
 	mutex_unlock(&misc_mtx);
@@ -279,7 +279,7 @@ static int __init misc_init(void)
 		goto fail_remove;
 
 	err = -EIO;
-	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
+	if (register_chrdev(MISC_MAJOR, "misc", &misc_fops))
 		goto fail_pr_err;
 	misc_class->devnode = misc_devnode;
 	return 0;
-- 
1.8.3.2

