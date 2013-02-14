Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab3BNMOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:14:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53219 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933987Ab3BNMOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:14:15 -0500
X-AuditID: cbfee68f-b7f466d000004a4e-53-511cd5110336
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de
Subject: [PATCH v6] iio: adc: add exynos adc driver under iio framwork
Date: Thu, 14 Feb 2013 17:41:30 +0530
Message-id: <1360843890-28466-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com>
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkRlfwqkygwaZbOhbzjrxjsbi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgyjj3YzVjwYkmxoruZ9MZGxg/ZnYxcnJICJhI
	vHz2lxXCFpO4cG89WxcjF4eQwFJGic8TtzLBFN2Y9YQZIrGIUWLy4gNgHUICPUwS3e0lIDab
	gJnEwUWr2bsYOThEBGQlZnbrgdQzCyxnlFhy7QM7SI2wgJvE4yPnGEFqWARUJRad0AQJ8wq4
	SrzYN4cNJCwhoCAxZ5INSJgTqHrJ0+/MEJtcJV7vXcICMlJC4DWbRP+5n2C3sQgISHybfIgF
	oldWYtMBZoiTJSUOrrjBMoFReAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwKA8/e9Z
	/w7GuwesDzEmA42byCwlmpwPDOq8knhDYxNzU2NTMyNLS0tT0oSVxHnlL8kECgmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamCUC09XNpJlKq3ez/1pjX81T9QM1s/Cr+bsyFbat1Z4yWH79tOu
	X/eylUW5zuPV1Frc4elSH1kvK/Gt3UVnj4NwdVZ04l578fbeo8wTKmKU/5y06V2ecMAweSHz
	H6M57UaVqsdb0/mO7Jhwe/vVcAP7//+4zvT0eF89vWHJMzF97b8bDOaITFViKc5INNRiLipO
	BACxCrRJYAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAV3BqzKBBp9vKlvMO/KOxeLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj3I/V
	jAUnmhgrup9NZ2xg/JjZxcjJISFgInFj1hNmCFtM4sK99WxdjFwcQgKLGCUmLz7ACpIQEuhh
	kuhuLwGx2QTMJA4uWs3excjBISIgKzGzWw+knllgOaPEkmsf2EFqhAXcJB4fOccIUsMioCqx
	6IQmSJhXwFXixb45bCBhCQEFiTmTbEDCnEDVS55+Z4bY5Crxeu8SlgmMvAsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBIf8M6kdjCsbLA4xCnAwKvHwKv6SDhRiTSwrrsw9xCjBwawk
	wvsyUCZQiDclsbIqtSg/vqg0J7X4EGMy0E0TmaVEk/OB8ZhXEm9obGJuamxqaWJhYmZJmrCS
	OC/jqScBQgLpiSWp2ampBalFMFuYODilGhiPr1O7LLM45FDv7vWbvBV4k3c85Fk7p+LvCa+g
	v9d4t0WUrnfsPBArfLuwqptz9hue085zXgjX6bRW+VSknrrOsej59o2H/yplvJn5hJcn7FbM
	X4nf3HHTzMXDys4H64j/2bt+ktuSa8vrHhTanrDff/+ipf7Hu3+CuiV3GSXbNQiedj1bFPtC
	iaU4I9FQi7moOBEAsvHKlb0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds New driver to support:
1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
   and future SoCs from Samsung
2. Add ADC driver under iio/adc framework
3. Also adds the Documentation for device tree bindings

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:

1. Fixed comments from Lars
2. Added support for ADC on EXYNOS5410

Changes since v2:

1. Changed the instance name for (struct iio_dev *) to indio_dev
2. Changed devm_request_irq to request_irq

Few doubts regarding the mappings and child device handling.
Kindly, suggest me better methods.

Changes since v3:

1. Added clk_prepare_disable and regulator_disable calls in _remove()
2. Moved init_completion before irq_request
3. Added NULL pointer check for devm_request_and_ioremap() return value.
4. Use number of channels as per the ADC version
5. Change the define ADC_V1_CHANNEL to ADC_CHANNEL
6. Update the Documentation to include EXYNOS5410 compatible

Changes since v4:

1. if devm_request_and_ioremap() failes, free iio_device before returning

Changes since v5:

1. Fixed comments from Olof (ADC hardware version handling)
2. Rebased on top of comming OF framework for IIO by "Guenter Roeck".

 .../bindings/arm/samsung/exynos5-adc.txt           |   42 ++
 drivers/iio/adc/Kconfig                            |    7 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/exynos_adc.c                       |  438 ++++++++++++++++++++
 4 files changed, 488 insertions(+)
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   52 +++
 drivers/iio/adc/Kconfig                            |    7 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/exynos_adc.c                       |  437 ++++++++++++++++++++
 4 files changed, 497 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
 create mode 100644 drivers/iio/adc/exynos_adc.c

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
new file mode 100644
index 0000000..f686378
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -0,0 +1,52 @@
+Samsung Exynos Analog to Digital Converter bindings
+
+This devicetree binding are for the new adc driver written fori
+Exynos4 and upward SoCs from Samsung.
+
+New driver handles the following
+1. Supports ADC IF found on EXYNOS4412/EXYNOS5250
+   and future SoCs from Samsung
+2. Add ADC driver under iio/adc framework
+3. Also adds the Documentation for device tree bindings
+
+Required properties:
+- compatible:		Must be "samsung,exynos-adc-v1"
+				for exynos4412/5250 controllers.
+			Must be "samsung,exynos-adc-v2" for
+				future controllers.
+- reg:			Contains ADC register address range (base address and
+			length).
+- interrupts: 		Contains the interrupt information for the timer. The
+			format is being dependent on which interrupt controller
+			the Samsung device uses.
+- #io-channel-cells = <1>; As ADC has multiple outputs
+
+Note: child nodes can be added for auto probing from device tree.
+
+Example: adding device info in dtsi file
+
+adc: adc@12D10000 {
+	compatible = "samsung,exynos-adc-v1";
+	reg = <0x12D10000 0x100>;
+	interrupts = <0 106 0>;
+	#io-channel-cells = <1>;
+	io-channel-ranges;
+};
+
+
+Example: Adding child nodes in dts file
+
+adc@12D10000 {
+
+	/* NTC thermistor is a hwmon device */
+	ncp15wb473@0 {
+		compatible = "ntc,ncp15wb473";
+		pullup-uV = <1800000>;
+		pullup-ohm = <47000>;
+		pulldown-ohm = <0>;
+		io-channels = <&adc 4>;
+	};
+};
+
+Note: Does not apply to ADC driver under arch/arm/plat-samsung/
+Note: The child node can be added under the adc node or seperately.
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index e372257..04311f8 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -91,6 +91,13 @@ config AT91_ADC
 	help
 	  Say yes here to build support for Atmel AT91 ADC.
 
+config EXYNOS_ADC
+	bool "Exynos ADC driver support"
+	help
+	  Core support for the ADC block found in the Samsung EXYNOS series
+	  of SoCs for drivers such as the touchscreen and hwmon to use to share
+	  this resource.
+
 config LP8788_ADC
 	bool "LP8788 ADC driver"
 	depends on MFD_LP8788
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 2d5f100..fabac2c 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_AD7791) += ad7791.o
 obj-$(CONFIG_AD7793) += ad7793.o
 obj-$(CONFIG_AD7887) += ad7887.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
+obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
 obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
 obj-$(CONFIG_MAX1363) += max1363.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
new file mode 100644
index 0000000..144a9e2
--- /dev/null
+++ b/drivers/iio/adc/exynos_adc.c
@@ -0,0 +1,437 @@
+/*
+ *  exynos_adc.c - Support for ADC in EXYNOS SoCs
+ *
+ *  8 ~ 10 channel, 10/12-bit ADC
+ *
+ *  Copyright (C) 2013 Naveen Krishna Chatradhi <ch.naveen@samsung.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/regulator/consumer.h>
+#include <linux/of_platform.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/machine.h>
+#include <linux/iio/driver.h>
+
+enum adc_version {
+	ADC_V1,
+	ADC_V2
+};
+
+/* EXYNOS4412/5250 ADC_V1 registers definitions */
+#define ADC_V1_CON(x)		((x) + 0x00)
+#define ADC_V1_DLY(x)		((x) + 0x08)
+#define ADC_V1_DATX(x)		((x) + 0x0C)
+#define ADC_V1_INTCLR(x)	((x) + 0x18)
+#define ADC_V1_MUX(x)		((x) + 0x1c)
+
+/* Future ADC_V2 registers definitions */
+#define ADC_V2_CON1(x)		((x) + 0x00)
+#define ADC_V2_CON2(x)		((x) + 0x04)
+#define ADC_V2_STAT(x)		((x) + 0x08)
+#define ADC_V2_INT_EN(x)	((x) + 0x10)
+#define ADC_V2_INT_ST(x)	((x) + 0x14)
+#define ADC_V2_VER(x)		((x) + 0x20)
+
+/* Bit definitions for ADC_V1 */
+#define ADC_V1_CON_RES		(1u << 16)
+#define ADC_V1_CON_PRSCEN	(1u << 14)
+#define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
+#define ADC_V1_CON_STANDBY	(1u << 2)
+
+/* Bit definitions for ADC_V2 */
+#define ADC_V2_CON1_SOFT_RESET	(1u << 2)
+
+#define ADC_V2_CON2_OSEL	(1u << 10)
+#define ADC_V2_CON2_ESEL	(1u << 9)
+#define ADC_V2_CON2_HIGHF	(1u << 8)
+#define ADC_V2_CON2_C_TIME(x)	(((x) & 7) << 4)
+#define ADC_V2_CON2_ACH_SEL(x)	(((x) & 0xF) << 0)
+#define ADC_V2_CON2_ACH_MASK	0xF
+
+#define MAX_ADC_V2_CHANNELS	10
+#define MAX_ADC_V1_CHANNELS	8
+
+/* Bit definitions common for ADC_V1 and ADC_V2 */
+#define ADC_CON_EN_START	(1u << 0)
+#define ADC_DATX_MASK		0xFFF
+
+struct exynos_adc {
+	void __iomem		*regs;
+	struct clk		*clk;
+	unsigned int		irq;
+	struct regulator	*vdd;
+
+	struct completion	completion;
+
+	u32			value;
+	unsigned int            version;
+};
+
+static const struct of_device_id exynos_adc_match[] = {
+	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
+	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_adc_match);
+
+static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos_adc_match, pdev->dev.of_node);
+	return (unsigned int)match->data;
+}
+
+static int exynos_read_raw(struct iio_dev *indio_dev,
+				struct iio_chan_spec const *chan,
+				int *val,
+				int *val2,
+				long mask)
+{
+	struct exynos_adc *info = iio_priv(indio_dev);
+	u32 con1, con2;
+
+	if (mask == IIO_CHAN_INFO_RAW) {
+		mutex_lock(&indio_dev->mlock);
+
+		/* Select the channel to be used and Trigger conversion */
+		if (info->version == ADC_V2) {
+			con2 = readl(ADC_V2_CON2(info->regs));
+			con2 &= ~ADC_V2_CON2_ACH_MASK;
+			con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
+			writel(con2, ADC_V2_CON2(info->regs));
+
+			con1 = readl(ADC_V2_CON1(info->regs));
+			writel(con1 | ADC_CON_EN_START,
+					ADC_V2_CON1(info->regs));
+		} else {
+			writel(chan->address, ADC_V1_MUX(info->regs));
+
+			con1 = readl(ADC_V1_CON(info->regs));
+			writel(con1 | ADC_CON_EN_START,
+					ADC_V1_CON(info->regs));
+		}
+
+		wait_for_completion(&info->completion);
+		*val = info->value;
+
+		mutex_unlock(&indio_dev->mlock);
+
+		return IIO_VAL_INT;
+	}
+
+	return -EINVAL;
+}
+
+static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
+{
+	struct exynos_adc *info = (struct exynos_adc *)dev_id;
+
+	/* Read value */
+	info->value = readl(ADC_V1_DATX(info->regs)) &
+						ADC_DATX_MASK;
+	/* clear irq */
+	if (info->version == ADC_V2)
+		writel(1, ADC_V2_INT_ST(info->regs));
+	else
+		writel(1, ADC_V1_INTCLR(info->regs));
+
+	complete(&info->completion);
+
+	return IRQ_HANDLED;
+}
+
+static int exynos_adc_reg_access(struct iio_dev *indio_dev,
+			      unsigned reg, unsigned writeval,
+			      unsigned *readval)
+{
+	struct exynos_adc *info = iio_priv(indio_dev);
+	u32 ret;
+
+	mutex_lock(&indio_dev->mlock);
+
+	if (readval != NULL) {
+		ret = readl(info->regs + reg);
+		*readval = ret;
+	} else
+		ret = -EINVAL;
+
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+static const struct iio_info exynos_adc_iio_info = {
+	.read_raw = &exynos_read_raw,
+	.debugfs_reg_access = &exynos_adc_reg_access,
+	.driver_module = THIS_MODULE,
+};
+
+#define ADC_CHANNEL(_index, _id) {			\
+	.type = IIO_VOLTAGE,				\
+	.indexed = 1,					\
+	.channel = _index,				\
+	.address = _index,				\
+	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
+	.datasheet_name = _id,				\
+}
+
+static const struct iio_chan_spec exynos_adc_iio_channels[] = {
+	ADC_CHANNEL(0, "adc0"),
+	ADC_CHANNEL(1, "adc1"),
+	ADC_CHANNEL(2, "adc2"),
+	ADC_CHANNEL(3, "adc3"),
+	ADC_CHANNEL(4, "adc4"),
+	ADC_CHANNEL(5, "adc5"),
+	ADC_CHANNEL(6, "adc6"),
+	ADC_CHANNEL(7, "adc7"),
+	ADC_CHANNEL(8, "adc8"),
+	ADC_CHANNEL(9, "adc9"),
+};
+
+static int exynos_adc_remove_devices(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
+static void exynos_adc_hw_init(struct exynos_adc *info)
+{
+	u32 con1, con2;
+
+	if (info->version == ADC_V2) {
+		con1 = ADC_V2_CON1_SOFT_RESET;
+		writel(con1, ADC_V2_CON1(info->regs));
+
+		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
+			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
+		writel(con2, ADC_V2_CON2(info->regs));
+
+		/* Enable interrupts */
+		writel(1, ADC_V2_INT_EN(info->regs));
+	} else {
+		/* set default prescaler values and Enable prescaler */
+		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+
+		/* Enable 12-bit ADC resolution */
+		con1 |= ADC_V1_CON_RES;
+		writel(con1, ADC_V1_CON(info->regs));
+	}
+}
+
+static int exynos_adc_probe(struct platform_device *pdev)
+{
+	struct exynos_adc *info = NULL;
+	struct device_node *np = pdev->dev.of_node;
+	struct iio_dev *indio_dev = NULL;
+	struct resource	*mem;
+	int ret = -ENODEV;
+	int irq;
+
+	if (!np)
+		return ret;
+
+	indio_dev = iio_device_alloc(sizeof(struct exynos_adc));
+	if (!indio_dev) {
+		dev_err(&pdev->dev, "failed allocating iio device\n");
+		return -ENOMEM;
+	}
+
+	info = iio_priv(indio_dev);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
+	if (!info->regs) {
+		ret = -ENOMEM;
+		goto err_iio;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		ret = irq;
+		goto err_iio;
+	}
+
+	info->irq = irq;
+
+	init_completion(&info->completion);
+
+	ret = request_irq(info->irq, exynos_adc_isr,
+					0, dev_name(&pdev->dev), info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed requesting irq, irq = %d\n",
+							info->irq);
+		goto err_iio;
+	}
+
+	info->clk = devm_clk_get(&pdev->dev, "adc");
+	if (IS_ERR(info->clk)) {
+		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
+							PTR_ERR(info->clk));
+		ret = PTR_ERR(info->clk);
+		goto err_irq;
+	}
+
+	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
+	if (IS_ERR(info->vdd)) {
+		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
+							PTR_ERR(info->vdd));
+		ret = PTR_ERR(info->vdd);
+		goto err_irq;
+	}
+
+	info->version = exynos_adc_get_version(pdev);
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	indio_dev->name = dev_name(&pdev->dev);
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->dev.of_node = pdev->dev.of_node;
+	indio_dev->info = &exynos_adc_iio_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->channels = exynos_adc_iio_channels;
+
+	if (info->version == ADC_V1)
+		indio_dev->num_channels = MAX_ADC_V1_CHANNELS;
+	else
+		indio_dev->num_channels = MAX_ADC_V2_CHANNELS;
+
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_irq;
+
+	ret = regulator_enable(info->vdd);
+	if (ret)
+		goto err_iio_dev;
+
+	clk_prepare_enable(info->clk);
+
+	exynos_adc_hw_init(info);
+
+	ret = of_platform_populate(np, exynos_adc_match, NULL, &pdev->dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed adding child nodes\n");
+		goto err_of_populate;
+	}
+
+	return 0;
+
+err_of_populate:
+	device_for_each_child(&pdev->dev, NULL, exynos_adc_remove_devices);
+	regulator_disable(info->vdd);
+	clk_disable_unprepare(info->clk);
+err_iio_dev:
+	iio_device_unregister(indio_dev);
+err_irq:
+	free_irq(info->irq, info);
+err_iio:
+	iio_device_free(indio_dev);
+	return ret;
+}
+
+static int exynos_adc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+	struct exynos_adc *info = iio_priv(indio_dev);
+
+	regulator_disable(info->vdd);
+	clk_disable_unprepare(info->clk);
+	iio_device_unregister(indio_dev);
+	free_irq(info->irq, info);
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int exynos_adc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_adc *info = platform_get_drvdata(pdev);
+	u32 con;
+
+	if (info->version == ADC_V2) {
+		con = readl(ADC_V2_CON1(info->regs));
+		con &= ~ADC_CON_EN_START;
+		writel(con, ADC_V2_CON1(info->regs));
+	} else {
+		con = readl(ADC_V1_CON(info->regs));
+		con |= ADC_V1_CON_STANDBY;
+		writel(con, ADC_V1_CON(info->regs));
+	}
+
+	clk_disable_unprepare(info->clk);
+	regulator_disable(info->vdd);
+
+	return 0;
+}
+
+static int exynos_adc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_adc *info = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = regulator_enable(info->vdd);
+	if (ret)
+		return ret;
+
+	clk_prepare_enable(info->clk);
+
+	exynos_adc_hw_init(info);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(exynos_adc_pm_ops,
+			exynos_adc_suspend,
+			exynos_adc_resume);
+
+static struct platform_driver exynos_adc_driver = {
+	.probe		= exynos_adc_probe,
+	.remove		= exynos_adc_remove,
+	.driver		= {
+		.name	= "exynos-adc",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(exynos_adc_match),
+		.pm	= &exynos_adc_pm_ops,
+	},
+};
+
+module_platform_driver(exynos_adc_driver);
+
+MODULE_AUTHOR("Naveen Krishna Chatradhi <ch.naveen@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS5 ADC driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

