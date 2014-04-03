Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaDCQVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:21:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63608 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaDCQV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:21:26 -0400
Message-ID: <533D8A82.7010107@gmail.com>
Date: Thu, 03 Apr 2014 17:21:22 +0100
From: paulmcquad <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Subject: [PATCH] Staging:ft1000_debug.c:Renaming __FUNCTION__
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f548b09a0fc387b94fee3372c0f7c4de1f281f80 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Thu, 3 Apr 2014 17:12:20 +0100
Subject: [PATCH] Staging:ft1000_debug.c:Renaming __FUNCTION__

__Function__ gets renamed with __func__

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index ffdc7f5..dc7647f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -785,7 +785,7 @@ static int ft1000_release(struct inode *inode, struct file *file)
 
     /* initialize application information */
     ft1000dev->appcnt--;
-    DEBUG("ft1000_chdev:%s:appcnt = %d\n", __FUNCTION__, ft1000dev->appcnt);
+    DEBUG("ft1000_chdev:%s:appcnt = %d\n", __func__, ft1000dev->appcnt);
     ft1000dev->app_info[i].fileobject = NULL;
 
     return 0;
-- 
1.8.3.2

