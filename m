Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3IIPe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:34:58 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:60388 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3IIPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:34:57 -0400
From: farisdehaan@gmail.com
To: gregkh@linuxfoundation.org
Cc: larry.finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Faris de Haan <farisdehaan@gmail.com>
Subject: [PATCH] Staging: rtl8188eu: checkpatch.pl warnings removed
Date: Mon,  9 Sep 2013 17:34:44 +0200
Message-Id: <522dea9f.47250e0a.0f3f.ffffc2dc@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Faris de Haan <farisdehaan@gmail.com>

Fixed some of the coding style issues reported by checkpatch.pl

Signed-off-by: Faris de Haan <farisdehaan@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index c2977be..cd3c9a7 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -267,9 +267,8 @@ _func_enter_;
 
 		rtw_mfree_sta_priv_lock(pstapriv);
 
-		if (pstapriv->pallocated_stainfo_buf) {
+		if (pstapriv->pallocated_stainfo_buf)
 			rtw_vmfree(pstapriv->pallocated_stainfo_buf, sizeof(struct sta_info)*NUM_STA+4);
-		}
 	}
 
 _func_exit_;
@@ -315,7 +314,7 @@ _func_enter_;
 
 		rtw_list_insert_tail(&psta->hash_list, phash_list);
 
-		pstapriv->asoc_sta_count++ ;
+		pstapriv->asoc_sta_count++;
 
 		_exit_critical_bh(&(pstapriv->sta_hash_lock), &irql2);
 
@@ -419,7 +418,7 @@ _func_enter_;
 	_cancel_timer_ex(&psta->addba_retry_timer);
 
 	/* for A-MPDU Rx reordering buffer control, cancel reordering_ctrl_timer */
-	for (i = 0; i < 16 ; i++) {
+	for (i = 0; i < 16; i++) {
 		unsigned long irql;
 		struct list_head *phead, *plist;
 		union recv_frame *prframe;
-- 
1.7.10.4

