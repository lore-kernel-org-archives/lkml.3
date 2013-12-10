Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3LJK4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:56:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64330 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3LJK4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:56:17 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-6d-52a6f3457f91
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: [PATCH RFC 3/4] xhci: Tune PHY for the DWC3-Exynos host controller
Date: Tue, 10 Dec 2013 16:25:25 +0530
Message-id: <1386672926-26885-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSo+v6eVmQwdZ3ehYH79dbNC9ez2Zx
	eeElVouOQ4+ZLHoXXGWzuPC0Byi2aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB26P2Q0XWTzm
	nQz02D93DbtH35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjfLoEr4+ec14wFd+Uqlmy+wNzA
	eE+ii5GTQ0LARKJjxWYWCFtM4sK99WxdjFwcQgJLGSUaN3WzwhRtPryGESIxnVFixo0XUM4U
	JonvH6cyglSxCehKNL3dBWaLCDhILFl6B2wUs8AtRomWqR1go4QFvCU+fJrCBGKzCKhK/G7Y
	BLabV8BD4tOMq1DrFCTe3H7GDGJzCnhKLO86ABYXAqrpun+fGWSohMA+dom7e1+zQwwSkPg2
	+RDQIA6ghKzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzA
	yDj979nEHYz3D1gfYkwGGjeRWUo0OR8YWXkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwNibe/vJoY/u98vsblf0FpTb267QlzW2OHTjor7Fba3K
	ZNuoU9ZXWxcu63jcJ3uh9ZxDw//+tZ62XvOZsjaqNjBW/vu4w4P7i9f7FxM8+Pr6Pnxfvatk
	amxujuzGlxveLa9wmbQyWGTi5keh53cfXCmh21t7wGhi/ae44riX4e6SUgwz5xeY/VBiKc5I
	NNRiLipOBACV3rEWogIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jQV3Xz8uCDM4sULU4eL/eonnxejaL
	ywsvsVp0HHrMZNG74CqbxYWnPUCxXXPYLGYv6WexmHF+H5PFomWtzBbNJ04xO3B7zG64yOIx
	72Sgx/65a9g9+rasYvQ4fmM7k8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwlrGDN+znnNWHBXrmLJ5gvMDYz3JLoYOTkkBEwkNh9ewwhhi0lcuLeerYuRi0NIYDqj
	xIwbLxghnClMEt8/TgWrYhPQlWh6uwvMFhFwkFiy9A5YB7PALUaJlqkdrCAJYQFviQ+fpjCB
	2CwCqhK/GzaxgNi8Ah4Sn2ZcZYVYpyDx5vYzZhCbU8BTYnnXAbC4EFBN1/37zBMYeRcwMqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI67Z9I7GFc1WBxiFOBgVOLhlfi3NEiINbGsuDL3
	EKMEB7OSCO+2F8uChHhTEiurUovy44tKc1KLDzEmA101kVlKNDkfmBLySuINjU3MTY1NLU0s
	TMwsSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoExbVOmu9PfxSZneO783H16q+O0ix+r
	XzXPfctlckQn0Wtuwyf35NqZrbtlN+68c/n0E5uPjxlapuzXbTtw7VdDwp6ZcXMW8txafM9o
	kreFXMeN5dlnvG9eqrlps3mud2Tvi1vuM5QkLm5J4Pf5/+aY04IzuVUMussb2ZqvXpmp9bDY
	/wzjt+BTzUosxRmJhlrMRcWJADA/5UT/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DWC3-exynos eXtensible host controller on Exynos5420 SoC
is quirky in a way that the PHY needs to be tuned to get it
working at SuperSpeed.
Add relevant calls for tuning the PHY for DWC3-Exynos's
host controller, for that matter passing just USB3 PHY
from DWC3 core, which is saved in secondary HCD of XHCI.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/host.c      |    7 ++++++
 drivers/usb/host/xhci-plat.c |   43 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/usb/hcd.h      |    1 +
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index 32db328..cc1f6ff 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -46,6 +46,13 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err1;
 	}
 
+	ret = platform_device_add_data(xhci, &dwc->usb3_generic_phy,
+					sizeof(dwc->usb3_generic_phy));
+	if (ret) {
+		dev_err(dwc->dev, "failed to add platform data\n");
+		goto err1;
+	}
+
 	ret = platform_device_add(xhci);
 	if (ret) {
 		dev_err(dwc->dev, "failed to register xHCI device\n");
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 395c9e9..a0f3cbc 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/dma-mapping.h>
+#include <linux/phy/phy.h>
 
 #include "xhci.h"
 
@@ -51,7 +52,24 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 /* called during probe() after chip reset completes */
 static int xhci_plat_setup(struct usb_hcd *hcd)
 {
-	return xhci_gen_setup(hcd, xhci_plat_quirks);
+	struct xhci_hcd	*xhci;
+	int ret = 0;
+
+	ret = xhci_gen_setup(hcd, xhci_plat_quirks);
+	if (ret) {
+		dev_err(hcd->self.controller, "xhci setup failed\n");
+		goto err0;
+	}
+
+	/* Valid for secondary HCD only which gives SuperSpeed ports */
+	if (!usb_hcd_is_primary_hcd(hcd)) {
+		xhci = hcd_to_xhci(hcd);
+		if (xhci->quirks & XHCI_DWC3_EXYNOS)
+			phy_tune(hcd->phy_generic);
+	}
+
+err0:
+	return ret;
 }
 
 static const struct hc_driver xhci_plat_xhci_driver = {
@@ -111,6 +129,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	struct usb_hcd		*hcd;
 	int			ret;
 	int			irq;
+	struct phy		**phy_generic;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -170,6 +189,15 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	}
 
 	/*
+	 * The parent of the xhci-plat device may pass in a PHY via
+	 * platform data.  If it exists, store it in our struct usb_hcd
+	 * so that we can use it later.
+	 */
+	phy_generic = dev_get_platdata(&pdev->dev);
+	if (phy_generic)
+		xhci->shared_hcd->phy_generic = *phy_generic;
+
+	/*
 	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
 	 * is called by usb_add_hcd().
 	 */
@@ -229,8 +257,19 @@ static int xhci_plat_resume(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	int ret;
+
+	ret = xhci_resume(xhci, 0);
+	if (ret)
+		return ret;
 
-	return xhci_resume(xhci, 0);
+	/* Valid for secondary HCD only which gives SuperSpeed ports */
+	if (!usb_hcd_is_primary_hcd(hcd)) {
+		if (xhci->quirks & XHCI_DWC3_EXYNOS)
+			phy_tune(hcd->phy_generic);
+	}
+
+	return 0;
 }
 
 static const struct dev_pm_ops xhci_plat_pm_ops = {
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index b8aba19..241ed2b 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -107,6 +107,7 @@ struct usb_hcd {
 	 * other external phys should be software-transparent
 	 */
 	struct usb_phy	*phy;
+	struct phy	*phy_generic;
 
 	/* Flags that need to be manipulated atomically because they can
 	 * change while the host controller is running.  Always use
-- 
1.7.6.5

