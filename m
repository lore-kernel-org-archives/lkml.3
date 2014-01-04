Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaADJN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 04:13:27 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:41672 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaADJNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 04:13:21 -0500
From: ritsz <r.ranjan789@gmail.com>
To: anton@enomsg.org
Cc: linux-kernel@vger.kernel.org, Ritesh Ranjan <r.ranjan789@gmail.com>
Subject: [PATCH] Power:	ab8500_charger:	Fixed coding style issues.
Date: Sat,  4 Jan 2014 09:13:09 +0000
Message-Id: <1388826789-16322-1-git-send-email-r.ranjan789@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues related to braces and space after comma.

Signed-off-by: Ritesh Ranjan <r.ranjan789@gmail.com>
---
 drivers/power/ab8500_charger.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 19110aa..7db36c9 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -385,17 +385,16 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 
 	/* write back the changed fallback bit value to register */
 	ret = abx500_set_register_interruptible(di->dev, bank, reg, val);
-	if (ret) {
+	if (ret)
 		dev_err(di->dev, "%d write failed\n", __LINE__);
-	}
+
 
 disable_otp:
 	if (is_ab8500(di->parent)) {
 		/* disable the set OTP registers again */
 		ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x0);
-		if (ret) {
+		if (ret)
 			dev_err(di->dev, "%d write failed\n", __LINE__);
-		}
 	}
 }
 
@@ -2397,7 +2396,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 		return;
 	}
 
-	dev_dbg(di->dev,"%s di->vbus_detected = true\n",__func__);
+	dev_dbg(di->dev, "%s di->vbus_detected = true\n", __func__);
 	di->vbus_detected = true;
 	ret = ab8500_charger_read_usb_type(di);
 	if (ret) {
-- 
1.8.4.2

