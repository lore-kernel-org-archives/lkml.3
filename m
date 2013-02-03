Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3BCQe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:34:56 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35793 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3BCQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:34:54 -0500
From: Severin Gsponer <svgsponer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Severin Gsponer <svgsponer@gmail.com>
Subject: [PATCH] Kernel: fix coding style issue in configs.c This is a patch to the configs.c file that fixes up a wrong placed * according to the coding style. Warning was found by checkpatch.pl tool
Date: Sun,  3 Feb 2013 17:34:44 +0000
Message-Id: <1359912884-17348-1-git-send-email-svgsponer@gmail.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Severin Gsponer <svgsponer@gmail.com>
---
 kernel/configs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/configs.c b/kernel/configs.c
index 42e8fa0..afa4232 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -56,7 +56,7 @@
 
 static ssize_t
 ikconfig_read_current(struct file *file, char __user *buf,
-		      size_t len, loff_t * offset)
+		      size_t len, loff_t *offset)
 {
 	return simple_read_from_buffer(buf, len, offset,
 				       kernel_config_data + MAGIC_SIZE,
-- 
1.7.12.4

