Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3AKO4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:56:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55012 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3AKO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:56:44 -0500
X-AuditID: cbfee61b-b7f616d00000319b-27-50f0282ba573
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, dianders@chromium.org,
        jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v6 4/4] USB: ohci-exynos: Add phy driver support
Date: Fri, 11 Jan 2013 20:32:30 +0530
Message-id: <1357916550-11421-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkSldb40OAwc9fXBaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZbyf2MRWcFO34u3ieSwNjP1qXYwcHBICJhJ7
	twt3MXICmWISF+6tZ+ti5OIQEljKKPG9pZkdImEicWLDCTBbSGARo8Tqu4YQRZOZJG6/O8YK
	kmAT0JVoeruLEcQWEZCVOHzlNzNIEbPAA6CijevAuoUFHCT2tc8Fa2ARUJW4N/kcWAOvgIdE
	y605zBDbFCTe3H4GZnMKeEqs3zSTEWKzh8TCiaugegUkvk0+xALxgazEpgNguyQEHrNJPF65
	H2qOpMTBFTdYJjAKL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRGJan/z2T3sG4qsHi
	EKMAB6MSD2+l5vsAIdbEsuLK3EOMEhzMSiK8XowfAoR4UxIrq1KL8uOLSnNSiw8x+gBdMpFZ
	SjQ5HxgzeSXxhsYm5qbGppZGRmampjiElcR5GU89CRASSE8sSc1OTS1ILYIZx8TBKdXAKMa3
	Qs8+o06ev/TGti1p7O1Gi3/4Ry6QELjI+Lu4ws+Ug2Hy5zsHsh4o8jd/9whmdYwM3TOt7eM5
	7UcH7ywo6PI0Zko6tervDrWzl6Nn/9wfsvpSC6+Hj2rV9Gs7HgUfTF5sotlYu+qTm8Ca7Ave
	92Ye+ZB2oWWh6eXKuxvDlZXP7Tz1YG3mVCWW4oxEQy3mouJEAIGtOT14AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAV0tjQ8BBu8vm1pc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxfmIT
	W8FN3Yq3i+exNDD2q3UxcnJICJhInNhwgh3CFpO4cG89G4gtJLCIUWL1XcMuRi4gezKTxO13
	x1hBEmwCuhJNb3cxgtgiArISh6/8ZgYpYhZ4AFS0cR3YJGEBB4l97XPBGlgEVCXuTT4H1sAr
	4CHRcmsOM8Q2BYk3t5+B2ZwCnhLrN81khNjsIbFw4irWCYy8CxgZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEh/0z6R2MqxosDjEKcDAq8fBWar4PEGJNLCuuzD3EKMHBrCTC68X4IUCI
	NyWxsiq1KD++qDQntfgQow/QVROZpUST84ExmVcSb2hsYm5qbGppYmFiZolDWEmcl/HUkwAh
	gfTEktTs1NSC1CKYcUwcnFINjJP9Juz/IW/7Y/Y0U+ulhZMDudPm/A+6t+GOQ7W207mteim3
	93w4WLp5ztnnrXnnFlbcT30t2OV4I2kygwzbPNP0DXvmCZoKMDRw3VL+/mWmwef8rl/T9297
	dTddOnt70inW3ZfnTZ/yn8HBbfmupRplEf/CWg5UWITvlZmwWniqCpf94TB/xplKLMUZiYZa
	zEXFiQCcrNz2qAIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the phy-driver to ohci-exynos. Keeping the platform data
for continuing the smooth operation for boards which still uses it

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/usb/host/ohci-exynos.c |   84 ++++++++++++++++++++++++++++++----------
 1 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 804fb62..1b38409 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-exynos.h>
+#include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
@@ -22,8 +23,31 @@ struct exynos_ohci_hcd {
 	struct device *dev;
 	struct usb_hcd *hcd;
 	struct clk *clk;
+	struct usb_phy *phy;
+	struct usb_otg *otg;
+	struct exynos4_ohci_platdata *pdata;
 };
 
+static void exynos_ohci_phy_enable(struct exynos_ohci_hcd *exynos_ohci)
+{
+	struct platform_device *pdev = to_platform_device(exynos_ohci->dev);
+
+	if (exynos_ohci->phy)
+		usb_phy_init(exynos_ohci->phy);
+	else if (exynos_ohci->pdata->phy_init)
+		exynos_ohci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+}
+
+static void exynos_ohci_phy_disable(struct exynos_ohci_hcd *exynos_ohci)
+{
+	struct platform_device *pdev = to_platform_device(exynos_ohci->dev);
+
+	if (exynos_ohci->phy)
+		usb_phy_shutdown(exynos_ohci->phy);
+	else if (exynos_ohci->pdata->phy_exit)
+		exynos_ohci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+}
+
 static int ohci_exynos_reset(struct usb_hcd *hcd)
 {
 	return ohci_init(hcd_to_ohci(hcd));
@@ -79,20 +103,15 @@ static u64 ohci_exynos_dma_mask = DMA_BIT_MASK(32);
 
 static int exynos_ohci_probe(struct platform_device *pdev)
 {
-	struct exynos4_ohci_platdata *pdata;
+	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_ohci_hcd *exynos_ohci;
 	struct usb_hcd *hcd;
 	struct ohci_hcd *ohci;
 	struct resource *res;
+	struct usb_phy *phy;
 	int irq;
 	int err;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "No platform data defined\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Right now device-tree probed devices don't get dma_mask set.
 	 * Since shared usb code relies on it, set it here for now.
@@ -108,6 +127,20 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	if (!exynos_ohci)
 		return -ENOMEM;
 
+	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+	if (IS_ERR_OR_NULL(phy)) {
+		/* Fallback to pdata */
+		if (!pdata) {
+			dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
+			return -EPROBE_DEFER;
+		} else {
+			exynos_ohci->pdata = pdata;
+		}
+	} else {
+		exynos_ohci->phy = phy;
+		exynos_ohci->otg = phy->otg;
+	}
+
 	exynos_ohci->dev = &pdev->dev;
 
 	hcd = usb_create_hcd(&exynos_ohci_hc_driver, &pdev->dev,
@@ -153,8 +186,11 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 		goto fail_io;
 	}
 
-	if (pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	if (exynos_ohci->otg)
+		exynos_ohci->otg->set_host(exynos_ohci->otg,
+					&exynos_ohci->hcd->self);
+
+	exynos_ohci_phy_enable(exynos_ohci);
 
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
@@ -162,13 +198,15 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to add USB HCD\n");
-		goto fail_io;
+		goto fail_add_hcd;
 	}
 
 	platform_set_drvdata(pdev, exynos_ohci);
 
 	return 0;
 
+fail_add_hcd:
+	exynos_ohci_phy_disable(exynos_ohci);
 fail_io:
 	clk_disable_unprepare(exynos_ohci->clk);
 fail_clk:
@@ -178,14 +216,16 @@ fail_clk:
 
 static int exynos_ohci_remove(struct platform_device *pdev)
 {
-	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_ohci_hcd *exynos_ohci = platform_get_drvdata(pdev);
 	struct usb_hcd *hcd = exynos_ohci->hcd;
 
 	usb_remove_hcd(hcd);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	if (exynos_ohci->otg)
+		exynos_ohci->otg->set_host(exynos_ohci->otg,
+					&exynos_ohci->hcd->self);
+
+	exynos_ohci_phy_disable(exynos_ohci);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -209,8 +249,6 @@ static int exynos_ohci_suspend(struct device *dev)
 	struct exynos_ohci_hcd *exynos_ohci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = exynos_ohci->hcd;
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 	unsigned long flags;
 	int rc = 0;
 
@@ -229,8 +267,11 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
-	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
+	if (exynos_ohci->otg)
+		exynos_ohci->otg->set_host(exynos_ohci->otg,
+					&exynos_ohci->hcd->self);
+
+	exynos_ohci_phy_disable(exynos_ohci);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -244,13 +285,14 @@ static int exynos_ohci_resume(struct device *dev)
 {
 	struct exynos_ohci_hcd *exynos_ohci = dev_get_drvdata(dev);
 	struct usb_hcd *hcd = exynos_ohci->hcd;
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos4_ohci_platdata *pdata = pdev->dev.platform_data;
 
 	clk_prepare_enable(exynos_ohci->clk);
 
-	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
+	if (exynos_ohci->otg)
+		exynos_ohci->otg->set_host(exynos_ohci->otg,
+					&exynos_ohci->hcd->self);
+
+	exynos_ohci_phy_enable(exynos_ohci);
 
 	ohci_resume(hcd, false);
 
-- 
1.7.6.5

