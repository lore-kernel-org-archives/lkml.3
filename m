Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3AUNjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:39:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8640 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3AUNjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:39:46 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-80-50fd45219254
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com
Subject: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
Date: Mon, 21 Jan 2013 19:07:50 +0530
Message-id: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkWlfR9W+AwYqJAhbzjrxjsbi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgymj6KF5wMLOiYeY8xgbGKWFdjJwcEgImElcW
	X2GEsMUkLtxbz9bFyMUhJLCUUeLErD52mKLn79Yyg9hCAtMZJXpmqUAU9TBJNJ55C5ZgEzCT
	OLhoNVADB4eIgKzEzG49kBpmgSmMEhO3vgKrERZwkZj79hOYzSKgKvH9/wYwm1fAVeLFugVM
	IL0SAgoScybZgPRKCJxgk/h69QA7RL2AxLfJh1ggamQlNh1ghrhNUuLgihssExgFFzAyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIDLHT/55J72Bc1WBxiFGAg1GJhzeh70+AEGtiWXFl
	7iFGCQ5mJRFeAfu/AUK8KYmVValF+fFFpTmpxYcYk4GWT2SWEk3OB4Z/Xkm8obGJuamxqaWR
	kZmpKWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpgDH69nofnSf/J989q2kS7jG4XSFZN
	4FOSyl/+I0WxSqfv4tvA6a/eH+kQWtmltnN3txJH9cePl8zO/TM8L817ha1Dfla+yqu1t//f
	09ySHccc4RsoaPpO7alx1osKy98dzr6LHvHPenTdZZVGft7OLJ5tPF/KV3zp0fh2QiE44Xpy
	qeOBwjAhJZbijERDLeai4kQA3Vt9aXUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQV0F178BBmveWlvMO/KOxeLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjGj6aN4
	wcHMioaZ8xgbGKeEdTFyckgImEg8f7eWGcIWk7hwbz0biC0kMJ1RomeWShcjF5DdwyTReOYt
	WBGbgJnEwUWr2bsYOThEBGQlZnbrgdQwC0xhlJi49RVYjbCAi8Tct5/AbBYBVYnv/zeA2bwC
	rhIv1i1gAumVEFCQmDPJZgIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQH8THoH
	46oGi0OMAhyMSjy8CX1/AoRYE8uKK3MPMUpwMCuJ8ArY/w0Q4k1JrKxKLcqPLyrNSS0+xJgM
	tHwis5Rocj4wuvJK4g2NTcxNjU0tTSxMzCxJE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dU
	A2Oyx52c/7UrNpuJ9VnI7GZT+GW3QHDJstz1H6XKP36etYiJv6VEuLWuzSo8seHXPzu3zsUZ
	s86YvHz8Pln5j4az3O+9129Z2v3uy7190JNB7394/Oz+uh4BwaSjp51/9By8fctk4h+zq1PZ
	1974HRiSEbu0IeriV4npIrF6RkEnLfd+u3uz6IISS3FGoqEWc1FxIgBqDMespAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an ADC IP found on EXYNOS5 series socs from Samsung.
Also adds the Documentation for device tree bindings.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 .../bindings/arm/samsung/exynos5-adc.txt           |   20 +
 drivers/iio/adc/Kconfig                            |    7 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/exynos5_adc.c                      |  412 ++++++++++++++++++++
 4 files changed, 440 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
 create mode 100644 drivers/iio/adc/exynos5_adc.c

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
new file mode 100644
index 0000000..069639e
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos5-adc.txt
@@ -0,0 +1,20 @@
+Samsung Exynos5 Analog to Digital Converter bindings
+
+Required properties:
+- compatible:		Must be "samsung,exynos5250-adc" for exynos5250 controllers.
+- reg:			Contains ADC register address range (base address and
+			length).
+- interrupts: 		Contains the interrupt information for the timer. The
+			format is being dependent on which interrupt controller
+			the Samsung device uses.
+
+Example:
+
+adc@12D10000 {
+	compatible = "samsung,exynos5250-adc";
+	reg = <0x12D10000 0x100>;
+	interrupts = <0 106 0>;
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+};
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index fe822a1..33ceabf 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -91,6 +91,13 @@ config AT91_ADC
 	help
 	  Say yes here to build support for Atmel AT91 ADC.
 
+config EXYNOS5_ADC
+	bool "Exynos5 ADC driver support"
+	help
+	  Core support for the ADC block found in the Samsung EXYNOS5 series
+	  of SoCs for drivers such as the touchscreen and hwmon to use to share
+	  this resource.
+
 config LP8788_ADC
 	bool "LP8788 ADC driver"
 	depends on MFD_LP8788
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 2d5f100..5b4a4f6 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_AD7791) += ad7791.o
 obj-$(CONFIG_AD7793) += ad7793.o
 obj-$(CONFIG_AD7887) += ad7887.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
+obj-$(CONFIG_EXYNOS5_ADC) += exynos5_adc.o
 obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
 obj-$(CONFIG_MAX1363) += max1363.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
diff --git a/drivers/iio/adc/exynos5_adc.c b/drivers/iio/adc/exynos5_adc.c
new file mode 100644
index 0000000..cd33ea2
--- /dev/null
+++ b/drivers/iio/adc/exynos5_adc.c
@@ -0,0 +1,412 @@
+/*
+ *  exynos5_adc.c - Support for ADC in EXYNOS5 SoCs
+ *
+ *  8-channel, 10/12-bit ADC
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
+/* Samsung ADC registers definitions */
+#define EXYNOS_ADC_CON(x)	((x) + 0x00)
+#define EXYNOS_ADC_DLY(x)	((x) + 0x08)
+#define EXYNOS_ADC_DATX(x)	((x) + 0x0C)
+#define EXYNOS_ADC_INTCLR(x)	((x) + 0x18)
+#define EXYNOS_ADC_MUX(x)	((x) + 0x1c)
+
+/* Bit definitions for EXYNOS_ADC_MUX: */
+#define ADC_RES		(1u << 16)
+#define ADC_ECFLG	(1u << 15)
+#define ADC_PRSCEN	(1u << 14)
+#define ADC_PRSCLV(x)	(((x) & 0xFF) << 6)
+#define ADC_PRSCVLMASK	(0xFF << 6)
+#define ADC_STANDBY	(1u << 2)
+#define ADC_READ_START	(1u << 1)
+#define ADC_EN_START	(1u << 0)
+
+#define ADC_DATX_MASK	0xFFF
+
+struct exynos5_adc {
+	void __iomem		*regs;
+	struct clk		*clk;
+	unsigned int		irq;
+	struct regulator	*vdd;
+
+	struct completion	completion;
+
+	struct iio_map		*map;
+	u32			value;
+	u32			prescale;
+};
+
+static const struct of_device_id exynos5_adc_match[] = {
+	{ .compatible = "samsung,exynos5250-adc" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos5_adc_match);
+
+/* default maps used by iio consumer (ex: ntc-thermistor driver) */
+static struct iio_map exynos5_adc_iio_maps[] = {
+	{
+		.consumer_dev_name = "0.ncp15wb473",
+		.consumer_channel = "adc_user3",
+		.adc_channel_label = "adc3",
+	},
+	{},
+};
+
+static int exynos5_read_raw(struct iio_dev *indio_dev,
+				struct iio_chan_spec const *chan,
+				int *val,
+				int *val2,
+				long mask)
+{
+	struct exynos5_adc *info = iio_priv(indio_dev);
+	u32 con;
+
+	if (mask == IIO_CHAN_INFO_RAW) {
+		mutex_lock(&indio_dev->mlock);
+
+		/* Select the channel to be used */
+		writel(chan->address, EXYNOS_ADC_MUX(info->regs));
+		/* Trigger conversion */
+		con = readl(EXYNOS_ADC_CON(info->regs));
+		writel(con | ADC_EN_START, EXYNOS_ADC_CON(info->regs));
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
+static irqreturn_t exynos5_adc_isr(int irq, void *dev_id)
+{
+	struct exynos5_adc *info = (struct exynos5_adc *)dev_id;
+
+	/* Read value and clear irq */
+	info->value = readl(EXYNOS_ADC_DATX(info->regs)) &
+				ADC_DATX_MASK;
+	writel(0, EXYNOS_ADC_INTCLR(info->regs));
+
+	complete(&info->completion);
+
+	return IRQ_HANDLED;
+}
+
+static int exynos5_adc_reg_access(struct iio_dev *indio_dev,
+			      unsigned reg, unsigned writeval,
+			      unsigned *readval)
+{
+	struct exynos5_adc *info = iio_priv(indio_dev);
+	u32 ret;
+
+	mutex_lock(&indio_dev->mlock);
+
+	if (readval != NULL) {
+		if (reg == 0x08)
+			ret = readl(EXYNOS_ADC_DLY(info->regs));
+		else if (reg == 0x0C)
+			ret = readl(EXYNOS_ADC_DATX(info->regs));
+		else if (reg == 0x1C)
+			ret = readl(EXYNOS_ADC_MUX(info->regs));
+		else
+			ret = readl(EXYNOS_ADC_CON(info->regs));
+
+		readval = &ret;
+	} else
+		ret = -EINVAL;
+
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+static const struct iio_info exynos5_adc_iio_info = {
+	.read_raw = &exynos5_read_raw,
+	.debugfs_reg_access = &exynos5_adc_reg_access,
+	.driver_module = THIS_MODULE,
+};
+
+#define EXYNOS_ADC_CHANNEL(_index, _id) {		\
+	.type = IIO_VOLTAGE,				\
+	.indexed = 1,					\
+	.channel = _index,				\
+	.address = _index,				\
+	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
+	.datasheet_name = _id,				\
+}
+
+static const struct iio_chan_spec exynos5_adc_iio_channels[] = {
+	EXYNOS_ADC_CHANNEL(0, "adc0"),
+	EXYNOS_ADC_CHANNEL(1, "adc1"),
+	EXYNOS_ADC_CHANNEL(2, "adc2"),
+	EXYNOS_ADC_CHANNEL(3, "adc3"),
+	EXYNOS_ADC_CHANNEL(4, "adc4"),
+	EXYNOS_ADC_CHANNEL(5, "adc5"),
+	EXYNOS_ADC_CHANNEL(6, "adc6"),
+	EXYNOS_ADC_CHANNEL(7, "adc7"),
+};
+
+static int exynos5_adc_iio_map_register(struct iio_dev *indio_dev,
+				struct exynos5_adc *adc)
+{
+	int ret;
+
+	adc->map = exynos5_adc_iio_maps;
+
+	ret = iio_map_array_register(indio_dev, adc->map);
+	if (ret) {
+		dev_err(&indio_dev->dev, "iio map err: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline void exynos5_adc_iio_map_unregister(struct iio_dev *indio_dev,
+				struct exynos5_adc *adc)
+{
+	iio_map_array_unregister(indio_dev, adc->map);
+}
+
+static int exynos5_adc_remove_devices(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
+static int exynos5_adc_probe(struct platform_device *pdev)
+{
+	struct exynos5_adc *info = NULL;
+	struct device_node *np = pdev->dev.of_node;
+	struct iio_dev *iodev = NULL;
+	struct resource	*mem;
+	int ret = -ENODEV;
+	int irq;
+	u32 con;
+
+	iodev = iio_device_alloc(sizeof(struct exynos5_adc));
+	if (!iodev) {
+		dev_err(&pdev->dev, "failed allocating iio device\n");
+		return -ENOMEM;
+	}
+
+	info = iio_priv(iodev);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "no mem resource?\n");
+		goto err_iio;
+	}
+
+	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
+	if (!info->regs) {
+		dev_err(&pdev->dev, "cannot map EXYNOS5 ADC registers\n");
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
+	ret = devm_request_irq(&pdev->dev, info->irq, exynos5_adc_isr,
+					0, dev_name(&pdev->dev), info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot request Samsung ADC IRQ %d\n",
+							info->irq);
+		goto err_iio;
+	}
+
+	info->clk = devm_clk_get(&pdev->dev, "adc");
+	if (IS_ERR(info->clk)) {
+		dev_err(&pdev->dev, "failed getting clock\n");
+		ret = PTR_ERR(info->clk);
+		goto err_iio;
+	}
+
+	clk_enable(info->clk);
+
+	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
+	if (IS_ERR(info->vdd)) {
+		dev_err(&pdev->dev, "operating without regulator \"vdd\" .\n");
+		ret = PTR_ERR(info->vdd);
+		goto err_iio;
+	}
+
+	platform_set_drvdata(pdev, iodev);
+
+	init_completion(&info->completion);
+
+	iodev->name = dev_name(&pdev->dev);
+	iodev->dev.parent = &pdev->dev;
+	iodev->dev.of_node = pdev->dev.of_node;
+	iodev->info = &exynos5_adc_iio_info;
+	iodev->modes = INDIO_DIRECT_MODE;
+	iodev->channels = exynos5_adc_iio_channels;
+	iodev->num_channels = ARRAY_SIZE(exynos5_adc_iio_channels);
+
+	/* Enable prescaler and set platform default */
+	info->prescale = ADC_PRSCLV(49);
+	con = info->prescale | ADC_PRSCEN;
+
+	/* Enable 12-bit ADC resolution */
+	con |= ADC_RES;
+
+	writel(con, EXYNOS_ADC_CON(info->regs));
+
+	ret = exynos5_adc_iio_map_register(iodev, info);
+	if (ret)
+		goto err_iio;
+
+	ret = iio_device_register(iodev);
+	if (ret)
+		goto err_map;
+
+	ret = regulator_enable(info->vdd);
+	if (ret)
+		goto err_iio_dev;
+
+	ret = of_platform_populate(np, exynos5_adc_match, NULL, &pdev->dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add child nodes\n");
+		goto err_of_populate;
+	}
+
+	dev_info(&pdev->dev, "EXYNOS5 ADC driver loaded.\n");
+
+	return 0;
+
+err_of_populate:
+	device_for_each_child(&pdev->dev, NULL, exynos5_adc_remove_devices);
+err_iio_dev:
+	iio_device_unregister(iodev);
+err_map:
+	exynos5_adc_iio_map_unregister(iodev, info);
+err_iio:
+	iio_device_free(iodev);
+	return ret;
+}
+
+static int exynos5_adc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *iodev = platform_get_drvdata(pdev);
+	struct exynos5_adc *info = iio_priv(iodev);
+
+	platform_set_drvdata(pdev, NULL);
+	iio_device_unregister(iodev);
+	exynos5_adc_iio_map_unregister(iodev, info);
+	iio_device_free(iodev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int exynos5_adc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
+	struct exynos5_adc *info = platform_get_drvdata(pdev);
+	u32 con;
+
+	con = readl(EXYNOS_ADC_CON(info->regs));
+	con |= ADC_STANDBY;
+	writel(con, EXYNOS_ADC_CON(info->regs));
+
+	clk_disable(info->clk);
+	regulator_disable(info->vdd);
+
+	return 0;
+}
+
+static int exynos5_adc_resume(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
+	struct exynos5_adc *info = platform_get_drvdata(pdev);
+	unsigned int con;
+	int ret;
+
+	ret = regulator_enable(info->vdd);
+	if (ret)
+		return ret;
+
+	clk_enable(info->clk);
+
+	/* TODO: Enable prescalar */
+	con = info->prescale | ADC_PRSCEN;
+	writel(con | ADC_RES, EXYNOS_ADC_CON(info->regs));
+
+	return 0;
+}
+
+#else
+#define s3c_adc_suspend NULL
+#define s3c_adc_resume NULL
+#endif
+
+static const struct dev_pm_ops adc_pm_ops = {
+	.suspend	= exynos5_adc_suspend,
+	.resume		= exynos5_adc_resume,
+};
+
+static struct platform_driver exynos5_adc_driver = {
+	.probe		= exynos5_adc_probe,
+	.remove		= exynos5_adc_remove,
+	.driver		= {
+		.name	= "exynos5-adc",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(exynos5_adc_match),
+		.pm	= &adc_pm_ops,
+	},
+};
+
+module_platform_driver(exynos5_adc_driver);
+
+MODULE_AUTHOR("Naveen Krishna Chatradhi <ch.naveen@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS5 ADC driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

