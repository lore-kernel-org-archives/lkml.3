Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbaDTIui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:50:38 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39304 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834AbaDTIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:50:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/10] staging: rtl8188eu: Remove unused enum LED_CTL_MODE members.
Date: Sun, 20 Apr 2014 14:17:18 +0530
Message-Id: <1397983638-10752-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_led.h |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index 2ad7e4a..c5194b6 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -30,20 +30,18 @@
 #define LED_BLINK_WPS_SUCESS_INTERVAL_ALPHA	5000
 
 enum LED_CTL_MODE {
-	LED_CTL_POWER_ON = 1,
-	LED_CTL_LINK = 2,
-	LED_CTL_NO_LINK = 3,
-	LED_CTL_TX = 4,
-	LED_CTL_RX = 5,
-	LED_CTL_SITE_SURVEY = 6,
-	LED_CTL_POWER_OFF = 7,
-	LED_CTL_START_TO_LINK = 8,
-	LED_CTL_START_WPS = 9,
-	LED_CTL_STOP_WPS = 10,
-	LED_CTL_START_WPS_BOTTON = 11, /* added for runtop */
-	LED_CTL_STOP_WPS_FAIL = 12, /* added for ALPHA */
-	LED_CTL_STOP_WPS_FAIL_OVERLAP = 13, /* added for BELKIN */
-	LED_CTL_CONNECTION_NO_TRANSFER = 14,
+	LED_CTL_POWER_ON,
+	LED_CTL_LINK,
+	LED_CTL_NO_LINK,
+	LED_CTL_TX,
+	LED_CTL_RX ,
+	LED_CTL_SITE_SURVEY,
+	LED_CTL_POWER_OFF,
+	LED_CTL_START_TO_LINK,
+	LED_CTL_START_WPS,
+	LED_CTL_STOP_WPS,
+	LED_CTL_START_WPS_BOTTON,
+	LED_CTL_STOP_WPS_FAIL
 };
 
 enum LED_STATE_871x {
-- 
1.7.10.4

