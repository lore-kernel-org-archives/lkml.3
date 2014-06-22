Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaFVIwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:05 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34981 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaFVIwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 30/42] staging: rtl8188eu: Remove unused inline function bitshift()
Date: Sun, 22 Jun 2014 14:21:34 +0530
Message-Id: <1403427107-12744-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index ca0957b..0b54856 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -215,16 +215,6 @@ static inline u32 _RND256(u32 sz)
 	return val;
 }
 
-static inline u32 bitshift(u32 bitmask)
-{
-	u32 i;
-
-	for (i = 0; i <= 31; i++)
-		if (((bitmask>>i) &  0x1) == 1)
-			break;
-	return i;
-}
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
-- 
1.7.10.4

