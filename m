Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaCHJ3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:29:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52757 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaCHJ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:35 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/28] usb: phy: twl4030-usb: Silence checkpatch warnings
Date: Sat, 8 Mar 2014 14:59:02 +0530
Message-ID: <1394270969-11851-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
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
index c3ace1d..6c7cec7 100644
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

