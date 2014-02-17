Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaBQI7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:59:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34151 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaBQI7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:30 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 1/8] usb: phy: twl4030-usb: Silence checkpatch warnings
Date: Mon, 17 Feb 2014 14:29:18 +0530
Message-ID: <1392627565-1829-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

Silences the following warnings:
WARNING: sizeof *twl should be sizeof(*twl)
WARNING: sizeof *otg should be sizeof(*otg)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index daf65e6..254c72c 100644
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
1.7.10.4

