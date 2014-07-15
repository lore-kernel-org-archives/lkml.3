Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaGORDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:03:08 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53328 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaGORCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:18 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 73/94] drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE
Date: Tue, 15 Jul 2014 20:01:28 +0300
Message-Id: <1405443709-15288-73-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

Allow phy-exynos-usb2 to be autoloaded based on devicetree information.
Tested on Odroid X2 with its USB subsystem build as modules.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
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
1.7.10.4

