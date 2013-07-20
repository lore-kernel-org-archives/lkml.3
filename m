Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3GTFn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 01:43:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28298 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3GTFnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 01:43:07 -0400
X-AuditID: cbfee68f-b7f436d000000f81-02-51ea2367d5f9
Date: Sat, 20 Jul 2013 05:43:02 +0000 (GMT)
From: NAVEEN KRISHNA CHATRADHI <ch.naveen@samsung.com>
Subject: Re: [PATCH] of: provide of_platform_unpopulate()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Roger Quadros <rogerq@ti.com>,
        George Cherian <george.cherian@ti.com>, Felipe Balbi <balbi@ti.com>
Reply-to: ch.naveen@samsung.com
MIME-version: 1.0
X-MTR: 20130720053751716@ch.naveen
Msgkey: 20130720053751716@ch.naveen
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130720053751716@ch.naveen
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <2333396.179421374298979822.JavaMail.weblogic@epml22>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSrZuu/CrQ4MAxDovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx8N02toIDmRVTph1jaWB8kNbFyMkhJKAi8XfHdFYQW0LARGLf
	rzOMELaYxIV769m6GLmAapYySrw7OJMRpujrxRMsEM3zGSWaF4SC2CwCqhJ377aCDWITMJd4
	d+IHmC0sYCnRumkSC8ggEYE+Rol7Z1vZQRxmgVssEl/XnGOCmCQvMWNiJ9hUXgFBiZMznwDZ
	HEDblCTePKoGMXkFlCW+/3aEuEFOYsnUy0wQNq/EjPanLDDxaV/XMEPY0hLnZ22Ae2bx98dQ
	cX6JY7d3MEFM55V4cj8YZszuzV/YIGwBialnDkK1qkv8WroMqpVPYs3CtywwY3adWs4M03t/
	y1ywc5gFFCWmdD9kh7ANJI4smsOK6ikQ21Hi/faJzBMYlWchSc1C0j4LSTuymgWMLKsYRVML
	kguKk9KLjPWKE3OLS/PS9ZLzczcxAtPC6X/P+ncw3j1gfYgxGRglE5mlRJPzgWklryTe0NjM
	yMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MisHafV8W7sh+
	cWOCyStHbX7bWwsXT9Sadm1bKu/ih7vOGETLa7/M9+HapnTxkd3kXAXWiY/sK+V6o6QKen49
	bpPL1+ids3L/v5VvPD5/aM69172bXT2z5ujPlLPPFvifYxCrzOs9HbJ1/herPLunjD9P3lM2
	t/zdvO5koeIrZ6bWc5wL/yhdV2Ipzkg01GIuKk4EAB6qi2YhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tmbppyq8CDeY8sbG4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRkH
	321jKziQWTFl2jGWBsYHaV2MnBxCAioSf3dMZwWxJQRMJL5ePMECYYtJXLi3ng2iZj6jRPOC
	UBCbRUBV4u7dVrB6NgFziXcnfoDZwgKWEq2bJgH1cnGICPQxStw728oO4jAL3GKR+LrmHBPE
	JHmJGRM7wTbwCghKnJz5BMjmANqmJPHmUTWIySugLPH9tyPEDXISS6ZeZoKweSVmtD9lgYlP
	+7qGGcKWljg/awMjzM2Lvz+GivNLHLu9gwliOq/Ek/vBMGN2b/7CBmELSEw9cxCqVV3i19Jl
	UK18EmsWvmWBGbPr1HJmmN77W+aCncMsoCgxpfshO4RtIHFk0RxWVE+B2I4S77dPZJ7AKDcL
	SWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYaRXnJhbXJqXrpecn7uJEZycni3awfjvvPUhRgEO
	RiUe3gsrXgYKsSaWFVfmHmKU4GBWEuFlvwMU4k1JrKxKLcqPLyrNSS0+xJgMjMCJzFKiyfnA
	xJlXEm9obGJuamxqYWBobm5GmrCSOO+zVutAIYH0xJLU7NTUgtQimC1MHJxSDYw8i3/tufk0
	PfKVx/zdv5a0n/vydumSzT/5d3395vLp+pwVBdt3iUs/sv8QN/maObOzW4YxP9/jec5SH242
	LLQrnJl1mjma7f+Rn3cW/3G+6nO29PM0KTX1io+9YU+LDN+5zbPwv3IqWMLXJE7nAsfM1Qp1
	c2Xde60aVi59OT8o5LnxzwDzis0BSizFGYmGWsxFxYkAfhbb7ZIDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6K5hlUp016614

Hello Sebastian,

I just did one more testing.

In case of iio/adc/exynos_adc.c there is a bug in the remove path.
If I fix the bug in the driver, with below patch

--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -375,14 +375,14 @@ static int exynos_adc_remove(struct platform_device *pdev)
        struct iio_dev *indio_dev = platform_get_drvdata(pdev);
        struct exynos_adc *info = iio_priv(indio_dev);

-       device_for_each_child(&pdev->dev, NULL,
-                               exynos_adc_remove_devices);
        regulator_disable(info->vdd);
        clk_disable_unprepare(info->clk);
        writel(0, info->enable_reg);
        iio_device_unregister(indio_dev);
        free_irq(info->irq, info);
        iio_device_free(indio_dev);
+       device_for_each_child(&pdev->dev, NULL,
+                               exynos_adc_remove_devices);

Even without your fix, I could configure it as a module and the rmmod, insmod are working fine. (no crash)

Regards,
Naveen
------- Original Message -------
Sender : Sebastian Andrzej Siewior<bigeasy@linutronix.de> 
Date   : Jul 19, 2013 23:44 (GMT+05:30)
Title  : [PATCH] of: provide of_platform_unpopulate()

So I called of_platform_populate() on a device to get each child device
probed and on rmmod and I need to reverse its doing. After a quick grep
I did what others did as well and rmmod ended in:

| Unable to handle kernel NULL pointer dereference at virtual address 00000018
| PC is at release_resource+0x18/0x80
| Process rmmod (pid: 2005, stack limit = 0xedc30238)
| [<c003add0>] (release_resource+0x18/0x80) from [<c0300e08>] (platform_device_del+0x78/0xac)
| [<c0300e08>] (platform_device_del+0x78/0xac) from [<c0301358>] (platform_device_unregister+0xc/0x18)

The problem is that platform_device_del() "releases" each ressource in its
tree. This does not work on platform_devices created by OF becuase they
were never added via insert_resource(). As a consequence old->parent in
__release_resource() is NULL and we explode while accessing ->child.
So I either I do something completly wrong _or_ nobody here tested the
rmmod path of their driver.

This patch provides a common function to unregister / remove devices
which added to the system via of_platform_populate(). While this works
now on my test case I have not tested any of the driver I modify here so
feedback is greatly appreciated.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: George Cherian <george.cherian@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/bus/omap-ocp2scp.c     | 13 ++-----------
 drivers/iio/adc/exynos_adc.c   | 15 ++-------------
 drivers/mfd/omap-usb-host.c    |  9 +--------
 drivers/of/platform.c          | 22 ++++++++++++++++++++++
 drivers/usb/dwc3/dwc3-exynos.c | 11 +----------
 drivers/usb/dwc3/dwc3-omap.c   | 12 +-----------
 include/linux/of_platform.h    |  4 ++++
 7 files changed, 33 insertions(+), 53 deletions(-)

diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
index 5511f98..510bb9e 100644
--- a/drivers/bus/omap-ocp2scp.c
+++ b/drivers/bus/omap-ocp2scp.c
@@ -23,15 +23,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
-static int ocp2scp_remove_devices(struct device *dev, void *c)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int omap_ocp2scp_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -51,7 +42,7 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 	return 0;
 
 err0:
-	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+	of_platform_unpopulate(&pdev->dev);
 
 	return ret;
 }
@@ -59,7 +50,7 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 static int omap_ocp2scp_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
-	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+	of_platform_unpopulate(&pdev->dev);
 
 	return 0;
 }
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 9809fc9..10248e1 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -216,15 +216,6 @@ static const struct iio_chan_spec exynos_adc_iio_channels[] = {
 	ADC_CHANNEL(9, "adc9"),
 };
 
-static int exynos_adc_remove_devices(struct device *dev, void *c)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static void exynos_adc_hw_init(struct exynos_adc *info)
 {
 	u32 con1, con2;
@@ -357,8 +348,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_populate:
-	device_for_each_child(&pdev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_unpopulate(&pdev->dev);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
 err_iio_dev:
@@ -375,8 +365,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct exynos_adc *info = iio_priv(indio_dev);
 
-	device_for_each_child(&pdev->dev, NULL,
-				exynos_adc_remove_devices);
+	of_platform_unpopulate(&pdev->dev);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
 	writel(0, info->enable_reg);
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 759fae3..bb26cea 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -832,13 +832,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int usbhs_omap_remove_child(struct device *dev, void *data)
-{
-	dev_info(dev, "unregistering
");
-	platform_device_unregister(to_platform_device(dev));
-	return 0;
-}
-
 /**
  * usbhs_omap_remove - shutdown processing for UHH & TLL HCDs
  * @pdev: USB Host Controller being removed
@@ -871,7 +864,7 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	/* remove children */
-	device_for_each_child(&pdev->dev, NULL, usbhs_omap_remove_child);
+	of_platform_unpopulate(&pdev->dev);
 	return 0;
 }
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index e0a6514..9cbb0c3 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -473,4 +473,26 @@ int of_platform_populate(struct device_node *root,
 	return rc;
 }
 EXPORT_SYMBOL_GPL(of_platform_populate);
+
+static int of_remove_populated_child(struct device *dev, void *d)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	of_device_unregister(pdev);
+	return 0;
+}
+/**
+ * of_platform_unpopulate() - Remove populated devices.
+ * @parent: parent of the populated devices.
+ *
+ * The reverse of of_platform_populate() and can only be used a parent was
+ * specified while invoking the former.
+ */
+void of_platform_unpopulate(struct device *parent)
+{
+	if (WARN_ON(!parent))
+		return;
+	device_for_each_child(parent, NULL, of_remove_populated_child);
+}
+EXPORT_SYMBOL_GPL(of_platform_unpopulate);
 #endif /* CONFIG_OF_ADDRESS */
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 8ce9d7f..2bf5664 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -86,15 +86,6 @@ static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
 	return ret;
 }
 
-static int dwc3_exynos_remove_child(struct device *dev, void *unused)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos;
@@ -164,7 +155,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
-	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
+	of_platform_unpopulate(&pdev->dev);
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 077f110..8688613 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -327,15 +327,6 @@ static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
 	return IRQ_HANDLED;
 }
 
-static int dwc3_omap_remove_core(struct device *dev, void *c)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static void dwc3_omap_enable_irqs(struct dwc3_omap *omap)
 {
 	u32			reg;
@@ -529,8 +520,7 @@ static int dwc3_omap_remove(struct platform_device *pdev)
 	dwc3_omap_disable_irqs(omap);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
-
+	of_platform_unpopulate(&pdev->dev);
 	return 0;
 }
 
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..e354f9c 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -72,6 +72,7 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
+extern  void of_platform_unpopulate(struct device *parent);
 #else
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
@@ -80,6 +81,9 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
+static inline void of_platform_unpopulate(struct device *parent)
+{
+}
 #endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.8.3.2

<p>&nbsp;</p><p>&nbsp;</p>Thanks & Best Regards,
Naveen Krishna Ch
SE @ Samsung-B.LABˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
