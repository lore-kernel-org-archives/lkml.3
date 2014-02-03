Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaBCIaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:30:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55151 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:29:59 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/3] usb: phy: twl4030-usb: Silence checkpatch warnings
Date: Mon,  3 Feb 2014 13:55:03 +0530
Message-Id: <1391415905-15341-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following warnings:
WARNING: sizeof *twl should be sizeof(*twl)
WARNING: sizeof *otg should be sizeof(*otg)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/phy/phy-twl4030-usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index daf65e68aaab..254c72c94370 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -661,7 +661,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	struct phy_provider	*phy_provider;
 	struct phy_init_data	*init_data = NULL;
 
-	twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
+	twl = devm_kzalloc(&pdev->dev, sizeof(*twl), GFP_KERNEL);
 	if (!twl)
 		return -ENOMEM;
 
@@ -676,7 +676,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	otg = devm_kzalloc(&pdev->dev, sizeof *otg, GFP_KERNEL);
+	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
 	if (!otg)
 		return -ENOMEM;
 
-- 
1.7.9.5

