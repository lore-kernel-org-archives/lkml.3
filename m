Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3JWTNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:13:31 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44858 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3JWTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:13:30 -0400
From: Chuong Ngo <cngo.github@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chuong Ngo <cngo.github@gmail.com>
Subject: [PATCH] drivers: staging: bcm:  Removed a developer debug statement.
Date: Wed, 23 Oct 2013 15:11:20 -0400
Message-Id: <1382555480-26605-1-git-send-email-cngo.github@gmail.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed a developer debug statement per the TODO list.  Additionally, removed braces for the if-statement to match coding style.

Signed-off-by: Chuong Ngo <cngo.github@gmail.com>
---
 drivers/staging/bcm/Bcmchar.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index f91bc1f..41554c8 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -49,11 +49,8 @@ static int bcm_char_release(struct inode *inode, struct file *filp)
 
 	pTarang = (struct bcm_tarang_data *)filp->private_data;
 
-	if (pTarang == NULL) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-				"ptarang is null\n");
+	if (pTarang == NULL)
 		return 0;
-	}
 
 	Adapter = pTarang->Adapter;
 
-- 
1.8.4.1

