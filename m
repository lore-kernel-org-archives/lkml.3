Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaJKS3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:29:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58654 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaJKS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:29:45 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] char: misc: remove trailing whitespaces
Date: Sat, 11 Oct 2014 23:59:30 +0530
Message-Id: <1413052170-2468-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/char/misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index b4cf821..cb32ea9 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -117,14 +117,14 @@ static int misc_open(struct inode *inode, struct file *file)
 	const struct file_operations *new_fops = NULL;
 
 	mutex_lock(&misc_mtx);
-	
+
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == minor) {
-			new_fops = fops_get(c->fops);		
+			new_fops = fops_get(c->fops);
 			break;
 		}
 	}
-		
+
 	if (!new_fops) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
@@ -162,7 +162,7 @@ static const struct file_operations misc_fops = {
 /**
  *	misc_register	-	register a miscellaneous device
  *	@misc: device structure
- *	
+ *
  *	Register a miscellaneous device with the kernel. If the minor
  *	number is set to %MISC_DYNAMIC_MINOR a minor number is assigned
  *	and placed in the minor field of the structure. For other cases
@@ -174,7 +174,7 @@ static const struct file_operations misc_fops = {
  *	A zero is returned on success and a negative errno code for
  *	failure.
  */
- 
+
 int misc_register(struct miscdevice *misc)
 {
 	dev_t dev;
-- 
1.8.3.2

