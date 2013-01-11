Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3AKICP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:02:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11819 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3AKICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:02:12 -0500
X-AuditID: cbfee61b-b7f616d00000319b-4e-50efc701e55b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, balbi@ti.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        sylvester.nawrocki@gmail.com, t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH] usb: phy: samsung: Add support to set pmu isolation
Date: Fri, 11 Jan 2013 13:38:58 +0530
Message-id: <1357891738-26259-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkTpfx+PsAg1vzzSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgypi26AlzwbH4ir7bcxkbGOf6djFyckgImEh8
	vL+OBcIWk7hwbz1bFyMXh5DAUkaJ+S1zWWGKJq5+wAqRWMQoce3SV7AOIYHJTBJH93mB2GwC
	uhJNb3cxgtgiArISh6/8ZgZpYBboYJH4/e0p2CRhAReJT0ens4HYLAKqEjv3b2ACsXkFPCRW
	nVnOCLFNQeLN7WfMEDUCEt8mHwJaxgEUl5XYdABspoTAGTaJRScfQ10nKXFwxQ2WCYyCCxgZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEBtrpf8+kdzCuarA4xCjAwajEw1up+T5AiDWx
	rLgy9xCjBAezkghvTS1QiDclsbIqtSg/vqg0J7X4EKMP0CUTmaVEk/OBUZBXEm9obGJuamxq
	aWRkZmqKQ1hJnJfx1JMAIYH0xJLU7NTUgtQimHFMHJxSDYwC06rkPU1u5M8y1D8rJHff9krk
	FammI/neJ2alHq/gicwWkbmmqPh+MtfOjopoE31rr15bEa+NJ64tisnp2/7r608PF7MAp/SJ
	+QXbDycKLUhmunhYOWfxkYn7r3w5ODNjfvDxXynRPtk5dyea9hltfHL2/S2zC6p55f+aWlbw
	HGfW25uu26/EUpyRaKjFXFScCABwxxDIYQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAV3G4+8DDH48kbC4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj2qIn
	zAXH4iv6bs9lbGCc69vFyMkhIWAiMXH1A1YIW0ziwr31bF2MXBxCAosYJa5d+soCkhASmMwk
	cXSfF4jNJqAr0fR2FyOILSIgK3H4ym9mkAZmgQ4Wid/fnoJNEhZwkfh0dDobiM0ioCqxc/8G
	JhCbV8BDYtWZ5YwQ2xQk3tx+xjyBkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAw
	fia9g3FVg8UhRgEORiUe3krN9wFCrIllxZW5hxglOJiVRHhraoFCvCmJlVWpRfnxRaU5qcWH
	GH2Atk9klhJNzgfGWF5JvKGxibmpsamliYWJmSUOYSVxXsZTTwKEBNITS1KzU1MLUotgxjFx
	cEo1MCYc/HvyBM/xEvvQTrmiqRN/37BjXsQUEne65dmj8/nNx8WKTBl936muk9I846K8VHHV
	jujqCiWu+Yw+NzXmrM+4Pj1r7XqvDxObjJR2qIhUHes38v24N2qN3QueT5Ie+jFKS2WiDntt
	ffrkVs4+pUX+W798VLtxhNlvceEJraOpjxUiHnh19CixFGckGmoxFxUnAgDh2++kkAIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse device node data in order to get
required properties to set pmu isolation for usb-phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Changes from v5:
 - Using a global spin_lock member in 'samsung_usbphy' structure to be
   used in samsung_usbphy_init() and samsung_usbphy_shutdown()
   to take care of all register initialization sequence.
 - Addressing few nits:
        - Using devphy_reg_offset instead of 'pmureg_devphy_offset'
        - Using if else block instead of ternary conditional statement
          in samsung_usbphy_set_isolation()
	- Using 'bool' type instead of 'int' for 'on' argument in
	  samsung_usbphy_set_isolation()
        - Amending few comments.

 .../devicetree/bindings/usb/samsung-usbphy.txt     |   36 +++++
 drivers/usb/phy/samsung-usbphy.c                   |  161 +++++++++++++++++---
 2 files changed, 175 insertions(+), 22 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 7b26e2d..22d06cf 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -9,3 +9,39 @@ Required properties:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
+
+Optional properties:
+- #address-cells: should be '1' when usbphy node has a child node with 'reg'
+		  property.
+- #size-cells: should be '1' when usbphy node has a child node with 'reg'
+	       property.
+- ranges: allows valid translation between child's address space and parent's
+	  address space.
+
+- The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
+  interface for usb-phy. It should provide the following information required by
+  usb-phy controller to control phy.
+  - reg : base physical address of PHY_CONTROL registers.
+	  The size of this register is the total sum of size of all PHY_CONTROL
+	  registers that the SoC has. For example, the size will be
+	  '0x4' in case we have only one PHY_CONTROL register (e.g.
+	  OTHERS register in S3C64XX or USB_PHY_CONTROL register in S5PV210)
+	  and, '0x8' in case we have two PHY_CONTROL registers (e.g.
+	  USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers in exynos4x).
+	  and so on.
+
+Example:
+ - Exynos4210
+
+	usbphy@125B0000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "samsung,exynos4210-usbphy";
+		reg = <0x125B0000 0x100>;
+		ranges;
+
+		usbphy-sys {
+			/* USB device and host PHY_CONTROL registers */
+			reg = <0x10020704 0x8>;
+		};
+	};
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 5c5e1bb5..7eec7c3 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/usb/otg.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
@@ -60,20 +61,46 @@
 #define MHZ (1000*1000)
 #endif
 
+#define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
+#define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
+
 enum samsung_cpu_type {
 	TYPE_S3C64XX,
 	TYPE_EXYNOS4210,
 };
 
 /*
+ * struct samsung_usbphy_drvdata - driver data for various SoC variants
+ * @cpu_type: machine identifier
+ * @devphy_en_mask: device phy enable mask for PHY CONTROL register
+ * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
+ *		       mapped address of system controller.
+ *
+ *	Here we have a separate mask for device type phy.
+ *	Having different masks for host and device type phy helps
+ *	in setting independent masks in case of SoCs like S5PV210,
+ *	in which PHY0 and PHY1 enable bits belong to same register
+ *	placed at position 0 and 1 respectively.
+ *	Although for newer SoCs like exynos these bits belong to
+ *	different registers altogether placed at position 0.
+ */
+struct samsung_usbphy_drvdata {
+	int cpu_type;
+	int devphy_en_mask;
+	u32 devphy_reg_offset;
+};
+
+/*
  * struct samsung_usbphy - transceiver driver state
  * @phy: transceiver structure
  * @plat: platform data
  * @dev: The parent device supplied to the probe function
  * @clk: usb phy clock
- * @regs: usb phy register memory base
+ * @regs: usb phy controller registers memory base
+ * @pmuregs: USB device PHY_CONTROL register memory base
  * @ref_clk_freq: reference clock frequency selection
- * @cpu_type: machine identifier
+ * @drv_data: driver data available for different SoCs
+ * @lock: lock for phy operations
  */
 struct samsung_usbphy {
 	struct usb_phy	phy;
@@ -81,12 +108,64 @@ struct samsung_usbphy {
 	struct device	*dev;
 	struct clk	*clk;
 	void __iomem	*regs;
+	void __iomem	*pmuregs;
 	int		ref_clk_freq;
-	int		cpu_type;
+	const struct samsung_usbphy_drvdata *drv_data;
+	spinlock_t	lock;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
 
+static int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
+{
+	struct device_node *usbphy_sys;
+
+	/* Getting node for system controller interface for usb-phy */
+	usbphy_sys = of_get_child_by_name(sphy->dev->of_node, "usbphy-sys");
+	if (!usbphy_sys)
+		dev_warn(sphy->dev, "No sys-controller interface for usb-phy\n");
+
+	sphy->pmuregs = of_iomap(usbphy_sys, 0);
+
+	of_node_put(usbphy_sys);
+
+	if (sphy->pmuregs == NULL) {
+		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * Set isolation here for phy.
+ * Here 'on = true' would mean USB PHY block is isolated, hence
+ * de-activated and vice-versa.
+ */
+static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
+{
+	void __iomem *reg;
+	u32 reg_val;
+	u32 en_mask;
+
+	if (!sphy->pmuregs) {
+		dev_warn(sphy->dev, "Can't set pmu isolation\n");
+		return;
+	}
+
+	reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
+	en_mask = sphy->drv_data->devphy_en_mask;
+
+	reg_val = readl(reg);
+
+	if (on)
+		reg_val &= ~en_mask;
+	else
+		reg_val |= en_mask;
+
+	writel(reg_val, reg);
+}
+
 /*
  * Returns reference clock frequency selection value
  */
@@ -112,7 +191,7 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 		refclk_freq = PHYCLK_CLKSEL_48M;
 		break;
 	default:
-		if (sphy->cpu_type == TYPE_S3C64XX)
+		if (sphy->drv_data->cpu_type == TYPE_S3C64XX)
 			refclk_freq = PHYCLK_CLKSEL_48M;
 		else
 			refclk_freq = PHYCLK_CLKSEL_24M;
@@ -135,7 +214,7 @@ static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
 	phypwr = readl(regs + SAMSUNG_PHYPWR);
 	rstcon = readl(regs + SAMSUNG_RSTCON);
 
-	switch (sphy->cpu_type) {
+	switch (sphy->drv_data->cpu_type) {
 	case TYPE_S3C64XX:
 		phyclk &= ~PHYCLK_COMMON_ON_N;
 		phypwr &= ~PHYPWR_NORMAL_MASK;
@@ -165,7 +244,7 @@ static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
 
 	phypwr = readl(regs + SAMSUNG_PHYPWR);
 
-	switch (sphy->cpu_type) {
+	switch (sphy->drv_data->cpu_type) {
 	case TYPE_S3C64XX:
 		phypwr |= PHYPWR_NORMAL_MASK;
 		break;
@@ -185,6 +264,7 @@ static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
 static int samsung_usbphy_init(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
+	unsigned long flags;
 	int ret = 0;
 
 	sphy = phy_to_sphy(phy);
@@ -196,13 +276,19 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 		return ret;
 	}
 
+	spin_lock_irqsave(&sphy->lock, flags);
+
 	/* Disable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
+	else
+		samsung_usbphy_set_isolation(sphy, false);
 
 	/* Initialize usb phy registers */
 	samsung_usbphy_enable(sphy);
 
+	spin_unlock_irqrestore(&sphy->lock, flags);
+
 	/* Disable the phy clock */
 	clk_disable_unprepare(sphy->clk);
 	return ret;
@@ -214,6 +300,7 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 static void samsung_usbphy_shutdown(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
+	unsigned long flags;
 
 	sphy = phy_to_sphy(phy);
 
@@ -222,44 +309,47 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
 		return;
 	}
 
+	spin_lock_irqsave(&sphy->lock, flags);
+
 	/* De-initialize usb phy registers */
 	samsung_usbphy_disable(sphy);
 
 	/* Enable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(true);
+	else
+		samsung_usbphy_set_isolation(sphy, true);
+
+	spin_unlock_irqrestore(&sphy->lock, flags);
 
 	clk_disable_unprepare(sphy->clk);
 }
 
 static const struct of_device_id samsung_usbphy_dt_match[];
 
-static inline int samsung_usbphy_get_driver_data(struct platform_device *pdev)
+static inline const struct samsung_usbphy_drvdata
+*samsung_usbphy_get_driver_data(struct platform_device *pdev)
 {
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(samsung_usbphy_dt_match,
 							pdev->dev.of_node);
-		return (int) match->data;
+		return match->data;
 	}
 
-	return platform_get_device_id(pdev)->driver_data;
+	return (struct samsung_usbphy_drvdata *)
+				platform_get_device_id(pdev)->driver_data;
 }
 
 static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy;
-	struct samsung_usbphy_data *pdata;
+	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
 	struct device *dev = &pdev->dev;
 	struct resource *phy_mem;
 	void __iomem	*phy_base;
 	struct clk *clk;
-
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "%s: no platform data defined\n", __func__);
-		return -EINVAL;
-	}
+	int ret;
 
 	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!phy_mem) {
@@ -283,7 +373,19 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	sphy->dev		= &pdev->dev;
+	sphy->dev = dev;
+
+	if (dev->of_node) {
+		ret = samsung_usbphy_parse_dt(sphy);
+		if (ret < 0)
+			return ret;
+	} else {
+		if (!pdata) {
+			dev_err(dev, "no platform data specified\n");
+			return -EINVAL;
+		}
+	}
+
 	sphy->plat		= pdata;
 	sphy->regs		= phy_base;
 	sphy->clk		= clk;
@@ -291,9 +393,11 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 	sphy->phy.label		= "samsung-usbphy";
 	sphy->phy.init		= samsung_usbphy_init;
 	sphy->phy.shutdown	= samsung_usbphy_shutdown;
-	sphy->cpu_type		= samsung_usbphy_get_driver_data(pdev);
+	sphy->drv_data		= samsung_usbphy_get_driver_data(pdev);
 	sphy->ref_clk_freq	= samsung_usbphy_get_refclk_freq(sphy);
 
+	spin_lock_init(&sphy->lock);
+
 	platform_set_drvdata(pdev, sphy);
 
 	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
@@ -305,17 +409,30 @@ static int __exit samsung_usbphy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
+	if (sphy->pmuregs)
+		iounmap(sphy->pmuregs);
+
 	return 0;
 }
 
+static const struct samsung_usbphy_drvdata usbphy_s3c64xx = {
+	.cpu_type		= TYPE_S3C64XX,
+	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+};
+
+static const struct samsung_usbphy_drvdata usbphy_exynos4 = {
+	.cpu_type		= TYPE_EXYNOS4210,
+	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id samsung_usbphy_dt_match[] = {
 	{
 		.compatible = "samsung,s3c64xx-usbphy",
-		.data = (void *)TYPE_S3C64XX,
+		.data = &usbphy_s3c64xx,
 	}, {
 		.compatible = "samsung,exynos4210-usbphy",
-		.data = (void *)TYPE_EXYNOS4210,
+		.data = &usbphy_exynos4,
 	},
 	{},
 };
@@ -325,10 +442,10 @@ MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
 static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	{
 		.name		= "s3c64xx-usbphy",
-		.driver_data	= TYPE_S3C64XX,
+		.driver_data	= (unsigned long)&usbphy_s3c64xx,
 	}, {
 		.name		= "exynos4210-usbphy",
-		.driver_data	= TYPE_EXYNOS4210,
+		.driver_data	= (unsigned long)&usbphy_exynos4,
 	},
 	{},
 };
-- 
1.7.6.5

