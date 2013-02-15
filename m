Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161379Ab3BOMqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:04 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:45315 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161347Ab3BOMp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:58 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/40] ab8500-charger: Trivial coding style changes
Date: Fri, 15 Feb 2013 12:44:37 +0000
Message-Id: <1360932310-30065-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enforce the white space character after 'if'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index fd3fa2b..dcd3c6f 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3152,10 +3152,10 @@ static int ab8500_charger_remove(struct platform_device *pdev)
 	destroy_workqueue(di->charger_wq);
 
 	flush_scheduled_work();
-	if(di->usb_chg.enabled)
+	if (di->usb_chg.enabled)
 		power_supply_unregister(&di->usb_chg.psy);
 #if !defined(CONFIG_CHARGER_PM2301)
-	if(di->ac_chg.enabled)
+	if (di->ac_chg.enabled)
 		power_supply_unregister(&di->ac_chg.psy);
 #endif
 	platform_set_drvdata(pdev, NULL);
@@ -3331,7 +3331,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	/* Register AC charger class */
-	if(di->ac_chg.enabled) {
+	if (di->ac_chg.enabled) {
 		ret = power_supply_register(di->dev, &di->ac_chg.psy);
 		if (ret) {
 			dev_err(di->dev, "failed to register AC charger\n");
@@ -3340,7 +3340,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	/* Register USB charger class */
-	if(di->usb_chg.enabled) {
+	if (di->usb_chg.enabled) {
 		ret = power_supply_register(di->dev, &di->usb_chg.psy);
 		if (ret) {
 			dev_err(di->dev, "failed to register USB charger\n");
@@ -3425,10 +3425,10 @@ free_irq:
 put_usb_phy:
 	usb_put_phy(di->usb_phy);
 free_usb:
-	if(di->usb_chg.enabled)
+	if (di->usb_chg.enabled)
 		power_supply_unregister(&di->usb_chg.psy);
 free_ac:
-	if(di->ac_chg.enabled)
+	if (di->ac_chg.enabled)
 		power_supply_unregister(&di->ac_chg.psy);
 free_charger_wq:
 	destroy_workqueue(di->charger_wq);
-- 
1.7.10.4

