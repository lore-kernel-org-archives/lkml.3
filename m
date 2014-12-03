Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaLCCeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:34:31 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:63118 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaLCCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:34:30 -0500
From: Paul Hedman <paul@mybboard.net>
X-Google-Original-From: Paul Hedman <paul@mybb.com>
To: paul@mybb.com, greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8712: Fixes brace coding style in rtl871x_sta_mgt.c
Date: Tue,  2 Dec 2014 20:34:13 -0600
Message-Id: <1417574053-5831-1-git-send-email-paul@mybb.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a brace warning in rtl871x_sta_mgt.c found
by the checkpatch.pl tool.

Signed-off-by: Paul Hedman <paul@mybb.com>
---
 drivers/staging/rtl8712/rtl871x_sta_mgt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 4c9b98e..de8acc1 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -83,9 +83,8 @@ static void mfree_all_stainfo(struct sta_priv *pstapriv)
 	spin_lock_irqsave(&pstapriv->sta_hash_lock, irqL);
 	phead = &pstapriv->free_sta_queue.queue;
 	plist = phead->next;
-	while ((end_of_queue_search(phead, plist)) == false) {
+	while ((end_of_queue_search(phead, plist)) == false)
 		plist = plist->next;
-	}
 
 	spin_unlock_irqrestore(&pstapriv->sta_hash_lock, irqL);
 }
-- 
2.1.0

