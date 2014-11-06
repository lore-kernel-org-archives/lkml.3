Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaKFX0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:26:04 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51085 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbaKFXZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:25:09 -0500
From: Krzysztof Konopko <kris@konagma.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: navin.patidar@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kris@konagma.com
Subject: [PATCH 3/3] rtl8188eu:  Remove leading spaces in rtw_led.c
Date: Fri,  7 Nov 2014 00:24:28 +0100
Message-Id: <1415316268-10278-3-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415316268-10278-2-git-send-email-kris@konagma.com>
References: <1415316268-10278-1-git-send-email-kris@konagma.com>
 <1415316268-10278-2-git-send-email-kris@konagma.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Linux coding convention leading spaces are not allowed.  This
patch removes leading spaces in rtw_led.c

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8188eu/core/rtw_led.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index 1b8264b..5d7e8ec 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -40,6 +40,7 @@ void BlinkTimerCallback(void *data)
 void BlinkWorkItemCallback(struct work_struct *work)
 {
 	struct LED_871x *pLed = container_of(work, struct LED_871x, BlinkWorkItem);
+
 	BlinkHandler(pLed);
 }
 
@@ -459,8 +460,8 @@ void LedControl8188eu(struct adapter *padapter, enum LED_CTL_MODE LedAction)
 {
 	struct led_priv *ledpriv = &(padapter->ledpriv);
 
-       if ((padapter->bSurpriseRemoved) || (padapter->bDriverStopped) ||
-	   (!padapter->hw_init_completed))
+	if ((padapter->bSurpriseRemoved) || (padapter->bDriverStopped) ||
+	    (!padapter->hw_init_completed))
 		return;
 
 	if (!ledpriv->bRegUseLed)
-- 
2.1.1

