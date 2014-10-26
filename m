Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaJZQS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:18:59 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51546 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaJZQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:18:58 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net
Subject: [PATCH 2/2] staging: rtl8723au:core
Date: Sun, 26 Oct 2014 16:18:52 +0000
Message-Id: <1414340332-4556-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: spaces required around that ':' (ctx:VxE)

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ieee80211.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
index 6274cb3..41006cf 100644
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -794,28 +794,28 @@ u16 rtw_mcs_rate23a(u8 rf_type, u8 bw_40MHz, u8 short_GI_20, u8 short_GI_40,
 
 	if (rf_type == RF_1T1R) {
 		if (mcs->rx_mask[0] & BIT(7))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?1500:1350) :
 				((short_GI_20)?722:650);
 		else if (mcs->rx_mask[0] & BIT(6))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?1350:1215) :
 				((short_GI_20)?650:585);
 		else if (mcs->rx_mask[0] & BIT(5))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?1200:1080) :
 				((short_GI_20)?578:520);
 		else if (mcs->rx_mask[0] & BIT(4))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?900:810) :
 				((short_GI_20)?433:390);
 		else if (mcs->rx_mask[0] & BIT(3))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?600:540) :
 				((short_GI_20)?289:260);
 		else if (mcs->rx_mask[0] & BIT(2))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?450:405) :
 				((short_GI_20)?217:195);
 		else if (mcs->rx_mask[0] & BIT(1))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?300:270) :
 				((short_GI_20)?144:130);
 		else if (mcs->rx_mask[0] & BIT(0))
-			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135):
+			max_rate = (bw_40MHz) ? ((short_GI_40)?150:135) :
 				((short_GI_20)?72:65);
 	} else {
 		if (mcs->rx_mask[1]) {
-- 
1.9.1

