Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3LJK5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:57:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44143 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3LJK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:56:09 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-9b-52a6f347c594
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: [PATCH RFC 4/4] phy-exynos-usb3: Fine tune LOS levels for exynos5420
Date: Tue, 10 Dec 2013 16:25:26 +0530
Message-id: <1386672926-26885-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSpev+eVmQwb0zahYH79dbNC9ez2Zx
	eeElVouOQ4+ZLHoXXGWzuPC0Byi2aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB26P2Q0XWTzm
	nQz02D93DbtH35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjfLoEr49zaPYwFH3UrfjTtZmtg
	vKjaxcjJISFgIvHm9htWCFtM4sK99WxdjFwcQgJLGSUuT+1l7GLkACvq+OUGUiMkMJ1RYsqr
	QIiaKUwSE9u72EASbAK6Ek1vdzGC2CICDhJLlt4BG8QscItRomVqB9gGYQFfidXf/zCB2CwC
	qhILz05lB7F5BTwkFqyZxgRxhQLQRc+YQWxOAU+J5V0HWCE2e0h03b/PDFGzj11iylUpiDkC
	Et8mH2KBOFRWYtMBqBJJiYMrbrBMYBRewMiwilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMw
	Jk7/e9a/g/HuAetDjMlA4yYyS4km5wNjKq8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KEBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MCbs8Dtv6XdFakeR7sRvf45UP99jvv+GeSyXuvprHpXr
	c1oUXXZND5gh9P7n0/c+MZ+Wxz22rpJQn7O5ze5olFfckXNvRb4z39+h9kko08NaU+SdI3P4
	EzN2Rp9L97ROq5/+/uJOc877qqrcjPgTZbNzfxoETMt50co7Mby19ui8zfUKP/fK/VViKc5I
	NNRiLipOBACkt79hnwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQV33z8uCDP71yVgcvF9v0bx4PZvF
	5YWXWC06Dj1msuhdcJXN4sLTHqDYrjlsFrOX9LNYzDi/j8li0bJWZovmE6eYHbg9ZjdcZPGY
	dzLQY//cNewefVtWMXocv7GdyePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
	Q11DSwtzJYW8xNxUWyUXnwBdt8wcoPOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1
	GBmggYQ1jBnn1u5hLPioW/GjaTdbA+NF1S5GDg4JAROJjl9uXYycQKaYxIV769lAbCGB6YwS
	U14FdjFyAdlTmCQmtneBJdgEdCWa3u5iBLFFBBwkliy9wwZSxCxwi1GiZWoHK0hCWMBXYvX3
	P0wgNouAqsTCs1PZQWxeAQ+JBWumMUFsU5B4c/sZM4jNKeApsbzrACvEZg+Jrvv3mScw8i5g
	ZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxzz6R2MK5ssDjEKMDBqMTDW8CwLEiINbGs
	uDL3EKMEB7OSCO+2F0Ah3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgemg7ySeENjE3NTY1NL
	EwsTM0vShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYOzSXNwQuP33Z5PLLaVTjvySfPFV
	QfQXwzo3zp7GuwfZmB4Ji3c0tUeU7ZrDu7mrP31irLmH1vlOFV/FUvcGx7Sqs3u1Rf0jP77r
	Cn82n9tfNWHus1khLc727kIMLwMjatrsXj4pO3rthJ680B6ugMVslYJKD7k7vrKZvkp8FrjO
	4dxHs+irSizFGYmGWsxFxYkAUKv7mv0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding phy tune callback, which facilitates tuning USB 3.0 PHY
present on Exynos5420.
Basically, Exynos5420 has 28nm PHY for which Loss-of-Signal (LOS)
Detector Threshold Level should be controlled for Super-Speed
operations. We are using CR_port for this purpose to send
required data to override the LOS values.

On testing with USB 3.0 devices on USB 3.0 port present on
SMDK5420, should see following message:
usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd

and without this patch, should see below shown message:
usb 2-1: new high-speed USB device number 2 using xhci-hcd

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-exynos5-usb3.c |  107 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usb3.c b/drivers/phy/phy-exynos5-usb3.c
index 2bafc9d..669f998 100644
--- a/drivers/phy/phy-exynos5-usb3.c
+++ b/drivers/phy/phy-exynos5-usb3.c
@@ -84,8 +84,20 @@
 #define PHYCLKRST_COMMONONN			(0x1 << 0)
 
 #define EXYNOS5_DRD_PHYREG0			(0x14)
+
+#define EXYNOS5_DRD_PHYREG0_SSC_REF_CLK_SEL	(1 << 21)
+#define EXYNOS5_DRD_PHYREG0_SSC_RANGE		(1 << 20)
+#define EXYNOS5_DRD_PHYREG0_CR_WRITE		(1 << 19)
+#define EXYNOS5_DRD_PHYREG0_CR_READ		(1 << 18)
+#define EXYNOS5_DRD_PHYREG0_CR_DATA_IN(_x)	((_x) << 2)
+#define EXYNOS5_DRD_PHYREG0_CR_CAP_DATA		(1 << 1)
+#define EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR		(1 << 0)
+
 #define EXYNOS5_DRD_PHYREG1			(0x18)
 
+#define EXYNOS5_DRD_PHYREG1_CR_DATA_OUT(_x)	((_x) << 1)
+#define EXYNOS5_DRD_PHYREG1_CR_ACK		(1 << 0)
+
 #define EXYNOS5_DRD_PHYPARAM0			(0x1c)
 
 #define PHYPARAM0_REF_USE_PAD			(0x1 << 31)
@@ -113,6 +125,18 @@
 #define EXYNOS5_DRD_PHYRESUME			(0x34)
 #define EXYNOS5_DRD_LINKPORT			(0x44)
 
+/* USB 3.0 DRD PHY SS Function Control Reg; accessed by CR_PORT */
+#define EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN		(0x15)
+
+#define LOSLEVEL_OVRD_IN_LOS_BIAS_5420			(0x5 << 13)
+#define LOSLEVEL_OVRD_IN_LOS_BIAS_DEFAULT		(0x0 << 13)
+#define LOSLEVEL_OVRD_IN_EN				(0x1 << 10)
+#define LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT		(0x9 << 0)
+
+#define EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN	(0x12)
+#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420		(0x5 << 13)
+#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_DEFAULT		(0x4 << 13)
+
 /* Power isolation defined in power management unit */
 #define EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET	(0x704)
 #define EXYNOS5_USB3DRD_PMU_ISOL		(1 << 0)
@@ -124,6 +148,7 @@ struct usb3phy_config {
 	bool has_usb30_sclk;
 	u32 reg_pmu_offset;
 	bool has_multi_controller;
+	bool need_crport_tuning;
 };
 
 struct usb3phy_driver {
@@ -235,6 +260,53 @@ static u32 exynos5_usb3phy_set_refclk(struct usb3phy_driver *drv)
 	return reg;
 }
 
+static void crport_handshake(struct usb3phy_driver *drv, u32 val, u32 cmd)
+{
+	u32 usec = 100;
+	u32 result;
+
+	writel(val | cmd, drv->reg_phy + EXYNOS5_DRD_PHYREG0);
+
+	do {
+		result = readl(drv->reg_phy + EXYNOS5_DRD_PHYREG1);
+		if (result & EXYNOS5_DRD_PHYREG1_CR_ACK)
+			break;
+
+		udelay(1);
+	} while (usec-- > 0);
+
+	if (!usec)
+		dev_err(drv->dev, "CRPORT handshake timeout1 (0x%08x)\n", val);
+
+	usec = 100;
+
+	writel(val, drv->reg_phy + EXYNOS5_DRD_PHYREG0);
+
+	do {
+		result = readl(drv->reg_phy + EXYNOS5_DRD_PHYREG1);
+		if (!(result & EXYNOS5_DRD_PHYREG1_CR_ACK))
+			break;
+
+		udelay(1);
+	} while (usec-- > 0);
+
+	if (!usec)
+		dev_err(drv->dev, "CRPORT handshake timeout2 (0x%08x)\n", val);
+}
+
+static void crport_ctrl_write(struct usb3phy_driver *drv, u32 addr, u32 data)
+{
+	/* Write Address */
+	crport_handshake(drv, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(addr),
+				EXYNOS5_DRD_PHYREG0_CR_CAP_ADDR);
+
+	/* Write Data */
+	crport_handshake(drv, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(data),
+				EXYNOS5_DRD_PHYREG0_CR_CAP_DATA);
+	crport_handshake(drv, EXYNOS5_DRD_PHYREG0_CR_DATA_IN(data),
+				EXYNOS5_DRD_PHYREG0_CR_WRITE);
+}
+
 static int exynos5_usb3phy_init(struct phy *phy)
 {
 	struct usb3phy_driver *drv = phy_get_drvdata(phy);
@@ -379,11 +451,44 @@ static int exynos5_usb3phy_power_off(struct phy *phy)
 	return 0;
 }
 
+static int exynos5_usb3phy_tune(struct phy *phy)
+{
+	struct usb3phy_driver *drv = phy_get_drvdata(phy);
+
+	if (drv->cfg->need_crport_tuning) {
+		u32 temp;
+		/*
+		 * Change los_bias to (0x5) for 28nm PHY from a
+		 * default value (0x0); los_level is set as default
+		 * (0x9) as also reflected in los_level[30:26] bits
+		 * of PHYPARAM0 register.
+		 */
+		temp = LOSLEVEL_OVRD_IN_LOS_BIAS_5420 |
+			LOSLEVEL_OVRD_IN_EN |
+			LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT;
+		crport_ctrl_write(drv,
+				  EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN,
+				  temp);
+
+		/*
+		 * Set tx_vboost_lvl to (0x5) for 28nm PHY Tuning,
+		 * to raise Tx signal level from its default value of (0x4)
+		 */
+		temp = TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420;
+		crport_ctrl_write(drv,
+				  EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN,
+				  temp);
+	}
+
+	return 0;
+}
+
 static struct phy_ops exynos5_usb3phy_ops = {
 	.init		= exynos5_usb3phy_init,
 	.exit		= exynos5_usb3phy_exit,
 	.power_on	= exynos5_usb3phy_power_on,
 	.power_off	= exynos5_usb3phy_power_off,
+	.tune		= exynos5_usb3phy_tune,
 	.owner		= THIS_MODULE,
 };
 
@@ -391,12 +496,14 @@ const struct usb3phy_config exynos5420_usb3phy_cfg = {
 	.has_usb30_sclk		= true,
 	.reg_pmu_offset		= EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
 	.has_multi_controller	= true,
+	.need_crport_tuning	= true,
 };
 
 const struct usb3phy_config exynos5250_usb3phy_cfg = {
 	.has_usb30_sclk		= false,
 	.reg_pmu_offset		= EXYNOS5_USB3DRD_PHY_PMU_REG_OFFSET,
 	.has_multi_controller	= false,
+	.need_crport_tuning	= false,
 };
 
 static const struct of_device_id exynos5_usb3phy_of_match[] = {
-- 
1.7.6.5

