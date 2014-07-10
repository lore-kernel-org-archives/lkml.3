Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaGJGZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:25:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55129 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaGJGZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:26 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE
Date: Thu, 10 Jul 2014 11:55:01 +0530
Message-ID: <1404973503-3310-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404973503-3310-1-git-send-email-kishon@ti.com>
References: <1404973503-3310-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

Allow phy-exynos-usb2 to be autoloaded based on devicetree information.
Tested on Odroid X2 with its USB subsystem build as modules.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-samsung-usb2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 8a8c6bc..1e69a32 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -107,6 +107,7 @@ static const struct of_device_id samsung_usb2_phy_of_match[] = {
 #endif
 	{ },
 };
+MODULE_DEVICE_TABLE(of, samsung_usb2_phy_of_match);
 
 static int samsung_usb2_phy_probe(struct platform_device *pdev)
 {
-- 
1.7.9.5

