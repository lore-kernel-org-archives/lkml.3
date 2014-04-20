Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbaDTIuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:50:08 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33046 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808AbaDTItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:49:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/10] staging: rtl8188eu: Remove unused macros.
Date: Sun, 20 Apr 2014 14:17:16 +0530
Message-Id: <1397983638-10752-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_led.h |   31 ---------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index ed1c687..2f81fab 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -23,39 +23,12 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-#define MSECS(t)        (HZ * ((t) / 1000) + (HZ * ((t) % 1000)) / 1000)
-
-#define LED_BLINK_NORMAL_INTERVAL		100
-#define LED_BLINK_SLOWLY_INTERVAL		200
-#define LED_BLINK_LONG_INTERVAL			400
-
 #define LED_BLINK_NO_LINK_INTERVAL_ALPHA	1000
 #define LED_BLINK_LINK_INTERVAL_ALPHA		500	/* 500 */
 #define LED_BLINK_SCAN_INTERVAL_ALPHA		180	/* 150 */
 #define LED_BLINK_FASTER_INTERVAL_ALPHA		50
 #define LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA	5000
 
-#define LED_BLINK_NORMAL_INTERVAL_NETTRONIX	100
-#define LED_BLINK_SLOWLY_INTERVAL_NETTRONIX	2000
-
-#define LED_BLINK_SLOWLY_INTERVAL_PORNET	1000
-#define LED_BLINK_NORMAL_INTERVAL_PORNET	100
-
-#define LED_BLINK_FAST_INTERVAL_BITLAND		30
-
-/*  060403, rcnjko: Customized for AzWave. */
-#define LED_CM2_BLINK_ON_INTERVAL		250
-#define LED_CM2_BLINK_OFF_INTERVAL		4750
-
-#define LED_CM8_BLINK_INTERVAL			500	/* for QMI */
-#define LED_CM8_BLINK_OFF_INTERVAL		3750	/* for QMI */
-
-/*  080124, lanhsin: Customized for RunTop */
-#define LED_RunTop_BLINK_INTERVAL		300
-
-/*  060421, rcnjko: Customized for Sercomm Printer Server case. */
-#define LED_CM3_BLINK_INTERVAL			1500
-
 enum LED_CTL_MODE {
 	LED_CTL_POWER_ON = 1,
 	LED_CTL_LINK = 2,
@@ -129,10 +102,6 @@ struct LED_871x {
 	((struct LED_871x *)_LED_871x)->CurrLedState == LED_BLINK_WPS_STOP || \
 	((struct LED_871x *)_LED_871x)->bLedWPSBlinkInProgress)
 
-#define IS_LED_BLINKING(_LED_871x)					\
-	(((struct LED_871x *)_LED_871x)->bLedWPSBlinkInProgress	||	\
-	((struct LED_871x *)_LED_871x)->bLedScanBlinkInProgress)
-
 void LedControl8188eu(struct adapter *padapter, enum LED_CTL_MODE	LedAction);
 
 struct led_priv{
-- 
1.7.10.4

