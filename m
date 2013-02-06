Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3BFKou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:44:50 -0500
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:53372 "EHLO
	mail.physik.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab3BFKoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:44:46 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2013 05:44:46 EST
Authentication-Results: dmz-sv-mailout.physik.uni-muenchen.de (amavisd-new);
	dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
	header.d=physik.uni-muenchen.de
From: Hans Grob <H.Grob@physik.uni-muenchen.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Hans Grob <H.Grob@physik.uni-muenchen.de>
Subject: [PATCH] drivers/char/mem.c: fix small coding style issues
Date: Wed,  6 Feb 2013 11:37:20 +0100
Message-Id: <1360147040-5940-1-git-send-email-H.Grob@physik.uni-muenchen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes four foo * bar errors, and one trailing whitespace
complaint from checkpatch.pl

Signed-off-by: Hans Grob <H.Grob@physik.uni-muenchen.de>
---
 drivers/char/mem.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 34e7cb1..3b9f289 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -400,7 +400,7 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 {
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
-	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	char *kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
 	int err = 0;
 
 	read = 0;
@@ -528,7 +528,7 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	unsigned long p = *ppos;
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
-	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
 	if (p < (unsigned long) high_memory) {
@@ -596,7 +596,7 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	unsigned long i = *ppos;
-	const char __user * tmp = buf;
+	const char __user *tmp = buf;
 
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
@@ -760,7 +760,7 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 	return ret;
 }
 
-static int open_port(struct inode * inode, struct file * filp)
+static int open_port(struct inode *inode, struct file *filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
@@ -934,7 +934,7 @@ static int __init chr_dev_init(void)
 			continue;
 
 		/*
-		 * Create /dev/port? 
+		 * Create /dev/port?
 		 */
 		if ((minor == DEVPORT_MINOR) && !arch_has_dev_port())
 			continue;
-- 
1.8.1.2

