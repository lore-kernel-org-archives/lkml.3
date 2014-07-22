Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaGVLDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:03:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56760 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbaGVK5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:17 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/28] phy: exynos5-usbdrd: Make local functions static
Date: Tue, 22 Jul 2014 16:26:28 +0530
Message-ID: <1406026611-30493-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jingoo Han <jg1.han@samsung.com>

Make local functions static, because these are used only in this
file.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 76d862b..205159d 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -506,7 +506,7 @@ static struct phy_ops exynos5_usbdrd_phy_ops = {
 	.owner		= THIS_MODULE,
 };
 
-const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
+static const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
 	{
 		.id		= EXYNOS5_DRDPHY_UTMI,
 		.phy_isol	= exynos5_usbdrd_phy_isol,
@@ -521,13 +521,13 @@ const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
 	},
 };
 
-const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
+static const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
 	.pmu_offset_usbdrd1_phy	= EXYNOS5420_USBDRD1_PHY_CONTROL,
 };
 
-const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
+static const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
 };
-- 
1.7.9.5

