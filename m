Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbaDIUBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:01:35 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59158 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDIUBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:01:34 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging:rtl8192e:rtl819x_BAProc:Remove whitespaces
Date: Wed,  9 Apr 2014 21:01:29 +0100
Message-Id: <1397073689-9658-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: spaces required around that '=' (ctx:OxW)

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8192e/rtl819x_BAProc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_BAProc.c b/drivers/staging/rtl8192e/rtl819x_BAProc.c
index adc6cc7..2aecdbd 100644
--- a/drivers/staging/rtl8192e/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_BAProc.c
@@ -109,9 +109,9 @@ static struct sk_buff *rtllib_ADDBA(struct rtllib_device *ieee, u8 *Dst,
 	BAReq->frame_ctl = cpu_to_le16(RTLLIB_STYPE_MANAGE_ACT);
 
 	tag = (u8 *)skb_put(skb, 9);
-	*tag ++= ACT_CAT_BA;
-	*tag ++= type;
-	*tag ++= pBA->DialogToken;
+	*tag++ = ACT_CAT_BA;
+	*tag++ = type;
+	*tag++ = pBA->DialogToken;
 
 	if (ACT_ADDBARSP == type) {
 		RT_TRACE(COMP_DBG, "====>to send ADDBARSP\n");
@@ -175,8 +175,8 @@ static struct sk_buff *rtllib_DELBA(struct rtllib_device *ieee, u8 *dst,
 
 	tag = (u8 *)skb_put(skb, 6);
 
-	*tag ++= ACT_CAT_BA;
-	*tag ++= ACT_DELBA;
+	*tag++ = ACT_CAT_BA;
+	*tag++ = ACT_DELBA;
 
 	tmp = DelbaParamSet.shortData;
 	memcpy(tag, (u8 *)&tmp, 2);
-- 
1.8.3.2

