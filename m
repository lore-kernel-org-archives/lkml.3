Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaJKSa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:30:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50993 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaJKSa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:30:27 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] char: misc: add missing blank line after declarations
Date: Sun, 12 Oct 2014 00:00:06 +0530
Message-Id: <1413052206-2519-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/char/misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index cb32ea9..3111e86 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -186,6 +186,7 @@ int misc_register(struct miscdevice *misc)
 
 	if (misc->minor == MISC_DYNAMIC_MINOR) {
 		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
+
 		if (i >= DYNAMIC_MINORS) {
 			err = -EBUSY;
 			goto out;
@@ -209,6 +210,7 @@ int misc_register(struct miscdevice *misc)
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
 		int i = DYNAMIC_MINORS - misc->minor - 1;
+
 		if (i < DYNAMIC_MINORS && i >= 0)
 			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
-- 
1.8.3.2

