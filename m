Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3EPSmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:42:32 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:64636 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3EPSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:42:31 -0400
From: bmheight@gmail.com
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, konkers@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Brandon Height <bmheight@gmail.com>
Subject: [PATCH] Staging: android: sync: fixed a brace coding style issue
Date: Thu, 16 May 2013 08:42:22 -1000
Message-Id: <1368729742-14948-1-git-send-email-bmheight@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Height <bmheight@gmail.com>

Fixed a coding style issue.

Signed-off-by: Brandon Height <bmheight@gmail.com>
---
 drivers/staging/android/sync.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 3893a35..36ed35e 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -125,9 +125,8 @@ static void sync_timeline_remove_pt(struct sync_pt *pt)
 	spin_unlock_irqrestore(&obj->active_list_lock, flags);
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
-	if (!list_empty(&pt->child_list)) {
+	if (!list_empty(&pt->child_list))
 		list_del_init(&pt->child_list);
-	}
 	spin_unlock_irqrestore(&obj->child_list_lock, flags);
 }
 
-- 
1.8.1.2

