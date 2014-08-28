Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbaH1K0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:26:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36026 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936586AbaH1K0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:26:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] phy: exynos5-usbdrd: Add MODULE_DEVICE_TABLE entry
Date: Thu, 28 Aug 2014 15:55:04 +0530
Message-ID: <1409221506-6262-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409221506-6262-1-git-send-email-kishon@ti.com>
References: <1409221506-6262-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

Add a MODULE_DEVICE_TABLE call for OF match tables. This allows the
module to be autoloaded based on devicetree information.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index b05302b..392101c 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -542,6 +542,7 @@ static const struct of_device_id exynos5_usbdrd_phy_of_match[] = {
 	},
 	{ },
 };
+MODULE_DEVICE_TABLE(of, exynos5_usbdrd_phy_of_match);
 
 static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 {
-- 
1.7.9.5

