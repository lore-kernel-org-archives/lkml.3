Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaIAArl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:47:41 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:55367 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIAArk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:47:40 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linux.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8723au: Fix return is not a function, parentheses are not required error
Date: Sun, 31 Aug 2014 19:46:19 -0500
Message-Id: <1409532379-1697-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl return is not a function, parentheses are not required error

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8723au/include/osdep_service.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/include/osdep_service.h b/drivers/staging/rtl8723au/include/osdep_service.h
index 51a5d7b..dedb418 100644
--- a/drivers/staging/rtl8723au/include/osdep_service.h
+++ b/drivers/staging/rtl8723au/include/osdep_service.h
@@ -54,7 +54,7 @@ struct rtw_queue {
 
 static inline struct list_head *get_list_head(struct rtw_queue *queue)
 {
-	return (&queue->queue);
+	return &queue->queue;
 }
 
 static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
-- 
1.9.1

