Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606AbaH1K0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:26:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51890 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936591AbaH1K0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:26:32 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] MAINTAINERS: add entry for the Samsung USB2 PHY driver
Date: Thu, 28 Aug 2014 15:55:05 +0530
Message-ID: <1409221506-6262-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409221506-6262-1-git-send-email-kishon@ti.com>
References: <1409221506-6262-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

Add MAINTAINERS entry for the Samsung USB2 PHY driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f01f54f2..a12a126 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7895,6 +7895,19 @@ S:	Supported
 L:	netdev@vger.kernel.org
 F:	drivers/net/ethernet/samsung/sxgbe/
 
+SAMSUNG USB2 PHY DRIVER
+M:	Kamil Debski <k.debski@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/phy/samsung-phy.txt
+F:	Documentation/phy/samsung-usb2.txt
+F:	drivers/phy/phy-exynos4210-usb2.c
+F:	drivers/phy/phy-exynos4x12-usb2.c
+F:	drivers/phy/phy-exynos5250-usb2.c
+F:	drivers/phy/phy-s5pv210-usb2.c
+F:	drivers/phy/phy-samsung-usb2.c
+F:	drivers/phy/phy-samsung-usb2.h
+
 SERIAL DRIVERS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
-- 
1.7.9.5

