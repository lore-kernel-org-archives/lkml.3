Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbaLOTXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:23:14 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35241 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaLOTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:23:13 -0500
From: Jack Wilson <jackwilson128@gmail.com>
To: gregkh@linuxfoundation.org, mail@beyermatthias.de, davej@redhat.com,
        ebru.akagunduz@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Jack Wilson <jackwilson128@gmail.com>
Subject: [PATCH] Staging: bcm: fix spaces before commas in Bcmchar.c
Date: Mon, 15 Dec 2014 11:22:29 -0800
Message-Id: <1418671349-4014-1-git-send-email-jackwilson128@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the Bcmchar.c file that fixes a space before comma warning found by checkpatch.pl.
Signed-off-by: Jack Wilson <jackwilson128@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 88ce2da..37a184a 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1647,7 +1647,7 @@ static int bcm_char_ioctl_flash2x_section_read(void __user *argp,
 
 	read_offset = flash_2x_read.offset;
 	OutPutBuff = io_buff.OutputBuffer;
-	read_buff = kzalloc(buff_size , GFP_KERNEL);
+	read_buff = kzalloc(buff_size, GFP_KERNEL);
 
 	if (read_buff == NULL) {
 		BCM_DEBUG_PRINT(ad, DBG_TYPE_PRINTK, 0, 0,
@@ -2192,7 +2192,7 @@ static int bcm_char_ioctl_nvm_raw_read(void __user *argp,
 	read_offset = nvm_read.uiOffset;
 	OutPutBuff = nvm_read.pBuffer;
 
-	read_buff = kzalloc(buff_size , GFP_KERNEL);
+	read_buff = kzalloc(buff_size, GFP_KERNEL);
 	if (read_buff == NULL) {
 		BCM_DEBUG_PRINT(ad, DBG_TYPE_PRINTK, 0, 0,
 				"Memory allocation failed for Flash 2.x Read Structure");
-- 
1.9.1

