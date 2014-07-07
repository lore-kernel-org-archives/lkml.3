Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaGGGsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:48:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49121 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaGGGst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:48:49 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE
Date: Mon, 7 Jul 2014 12:18:21 +0530
Message-ID: <1404715705-5041-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404715705-5041-1-git-send-email-kishon@ti.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
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

