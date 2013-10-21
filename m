Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3JUG5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 02:57:39 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49317 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3JUG5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 02:57:38 -0400
From: Chuong Ngo <cngo.github@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chuong Ngo <cngo.github@gmail.com>
Subject: [PATCH] drivers: staging: bcm: removed a developer debug message per the TODO list.
Date: Mon, 21 Oct 2013 02:57:24 -0400
Message-Id: <1382338644-7984-1-git-send-email-cngo.github@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a debug message as outlined in the TODO list.
---
 drivers/staging/bcm/Bcmchar.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index f91bc1f..526594b 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -50,8 +50,6 @@ static int bcm_char_release(struct inode *inode, struct file *filp)
 	pTarang = (struct bcm_tarang_data *)filp->private_data;
 
 	if (pTarang == NULL) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-				"ptarang is null\n");
 		return 0;
 	}
 
-- 
1.7.10.4

