Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaJKS2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:28:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38539 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaJKS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:28:35 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] char: misc: fix coding style issues
Date: Sat, 11 Oct 2014 23:57:58 +0530
Message-Id: <1413052078-2419-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl error
ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index ffa97d2..b4cf821 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -109,7 +109,7 @@ static const struct file_operations misc_proc_fops = {
 };
 #endif
 
-static int misc_open(struct inode * inode, struct file * file)
+static int misc_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
 	struct miscdevice *c;
@@ -175,7 +175,7 @@ static const struct file_operations misc_fops = {
  *	failure.
  */
  
-int misc_register(struct miscdevice * misc)
+int misc_register(struct miscdevice *misc)
 {
 	dev_t dev;
 	int err = 0;
-- 
1.8.3.2

