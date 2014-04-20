Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbaDTIuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:50:14 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53903 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823AbaDTItx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:49:53 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/10] staging: rtl8188eu: Remove unused enum LED_STATE_871x members.
Date: Sun, 20 Apr 2014 14:17:17 +0530
Message-Id: <1397983638-10752-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_led.h |   30 +++++++++------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index 2f81fab..2ad7e4a 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -47,26 +47,16 @@ enum LED_CTL_MODE {
 };
 
 enum LED_STATE_871x {
-	LED_UNKNOWN = 0,
-	RTW_LED_ON = 1,
-	RTW_LED_OFF = 2,
-	LED_BLINK_NORMAL = 3,
-	LED_BLINK_SLOWLY = 4,
-	LED_BLINK_POWER_ON = 5,
-	LED_BLINK_SCAN = 6, /*  LED is blinking during scanning period,
-			     * the # of times to blink is depend on time
-			     * for scanning. */
-	LED_BLINK_NO_LINK = 7, /*  LED is blinking during no link state. */
-	LED_BLINK_StartToBlink = 8,/*  Customzied for Sercomm Printer
-				    * Server case */
-	LED_BLINK_TXRX = 9,
-	LED_BLINK_WPS = 10,	/*  LED is blinkg during WPS communication */
-	LED_BLINK_WPS_STOP = 11,	/* for ALPHA */
-	LED_BLINK_WPS_STOP_OVERLAP = 12,	/* for BELKIN */
-	LED_BLINK_RUNTOP = 13, /*  Customized for RunTop */
-	LED_BLINK_CAMEO = 14,
-	LED_BLINK_XAVI = 15,
-	LED_BLINK_ALWAYS_ON = 16,
+	LED_UNKNOWN,
+	RTW_LED_ON,
+	RTW_LED_OFF,
+	LED_BLINK_NORMAL,
+	LED_BLINK_SLOWLY,
+	LED_BLINK_POWER_ON,
+	LED_BLINK_SCAN,
+	LED_BLINK_TXRX,
+	LED_BLINK_WPS,
+	LED_BLINK_WPS_STOP
 };
 
 struct LED_871x {
-- 
1.7.10.4

