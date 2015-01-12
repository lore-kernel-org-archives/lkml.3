Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbbALBlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 20:41:46 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:45526 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbALBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 20:41:45 -0500
From: Rene Kolarik <rene.kolarik@gmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rene Kolarik <rene.kolarik@gmail.com>
Subject: [PATCH] drivers: staging: rtl8192u driver cleanup
Date: Mon, 12 Jan 2015 02:31:57 +0100
Message-Id: <1421026317-20729-1-git-send-email-rene.kolarik@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct redundant initialization reported by sparse

Signed-off-by: Rene Kolarik <rene.kolarik@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index c451410..acaa723 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -241,7 +241,7 @@ static PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee,
 {
 	//DIRECTION_VALUE	dir;
 	u8	dir;
-	bool				search_dir[4] = {0, 0, 0, 0};
+	bool				search_dir[4] = {0};
 	struct list_head		*psearch_list; //FIXME
 	PTS_COMMON_INFO	pRet = NULL;
 	if(ieee->iw_mode == IW_MODE_MASTER) //ap mode
-- 
1.9.3

