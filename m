Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaGGNWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:22:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59247 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaGGNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:22:09 -0400
X-AuditID: cbfee68f-b7fef6d000003970-e0-53ba9edffbb0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Peter Griffin'" <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Maxime Coquelin'" <maxime.coquelin@st.com>,
        "'Patrice Chotard'" <patrice.chotard@st.com>,
        "'Srinivas Kandagatla'" <srinivas.kandagatla@gmail.com>,
        devicetree@vger.kernel.org, "'Felipe Balbi'" <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Giuseppe Cavallaro'" <peppe.cavallaro@st.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
In-reply-to: <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC
Date: Mon, 07 Jul 2014 22:21:34 +0900
Message-id: <000d01cf99e6$602096b0$2061c410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+YGjhok2ogFy92Q/+oCKy5F6f8nwByTakg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zoe79ebuCDb4f1bY4eL/e4uUhTYv5
	R86xWlxeeInV4v7Xo4wWmx5fA3J3zWGzmL2kn8Vi0bJWZotHpxezWcw5cZXR4v/rrYwWG2b8
	Y7Fo+xbnwOexc9Zddo871/aweWxeUu/Rt2UVo8fTH3uZPY7f2M7k8XmTXAB7FJdNSmpOZllq
	kb5dAlfG5SsvGQuep1Q0XjjD3sD4J7CLkZNDQsBEore1gRnCFpO4cG89WxcjF4eQwDJGiWuz
	zzHDFJ0/uYkZIjGdUeL6sy0sEM5vRonWrmZ2kCo2ATWJL18Og9kiAnoSj9cuBhvFLHCOWeLl
	3olQ7e2MEjf71jCCVHEKeEpcXL2FtYuRg0NYwF9i1WIvkDCLgKrEhld/wFbzCthKTPjeCGUL
	SvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkDESAuoSj/7qQtxgJNG/YC8bRImIxL4X7xhBTpAQ
	WMkhsX5WGzPELgGJb5MPsUD0ykpsOgD1saTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UXGesWJucWleel6yfm5mxghKaF/B+PdA9aHGJOB1k9klhJNzgemlLySeENjMyML
	UxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwKhyJZ3bsD5I19Xn
	HOOkSJY508LW+hSu2HpLZEvYNpUwSQYZvtfiUo+fPNG4c/rRZZGYfTNndMvmnpob/rTg8uvc
	bZ0LQmQ83bzCa57zxtT0mj07eEdu/rIrzadkDpnscWa0Z86zM5Y25VIUXfb9YrP4k9LvNy5+
	iNrvZGj7OLSmJcPl5vkn4kosxRmJhlrMRcWJAN7mMrwfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd3783YFG1x6pWJx8H69xctDmhbz
	j5xjtbi88BKrxf2vRxktNj2+BuTumsNmMXtJP4vFomWtzBaPTi9ms5hz4iqjxf/XWxktNsz4
	x2LR9i3Ogc9j56y77B53ru1h89i8pN6jb8sqRo+nP/Yyexy/sZ3J4/MmuQD2qAZGm4zUxJTU
	IoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygg5UUyhJzSoFCAYnF
	xUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGZevvGQseJ5S0XjhDHsD45/ALkZODgkBE4nz
	JzcxQ9hiEhfurWfrYuTiEBKYzihx/dkWFgjnN6NEa1czO0gVm4CaxJcvh8FsEQE9icdrF4N1
	MAucY5Z4uXciM0RHO6PEzb41jCBVnAKeEhdXb2HtYuTgEBbwl1i12AskzCKgKrHh1R+w1bwC
	thITvjdC2YISPybfYwGxmQW0JNbvPM4EYctLbF7zlhlkjISAusSjv7oQNxhJ9C/YywZRIiKx
	78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM44TyT
	3sG4qsHiEKMAB6MSD++BVTuDhVgTy4orcw8xSnAwK4nwTo/fFSzEm5JYWZValB9fVJqTWnyI
	0RTo0YnMUqLJ+cBkmFcSb2hsYmZkaWRmYWRibq4kznuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1Oq
	gbFwx/KlSqtVDc2fnQh3ZZ0x1VNrTianrmPSTrkXTRYLVygI3WEru/ZAXTbvXaf5bhFL+/gF
	9aF2R0MKJ12pnrBmQWiqiSjz3llXbA6+e2lTNGPWGu60xE+n85IOFW4M32Rz0etQMV+SqYF/
	7gNXodcnFVflNvrNe9f48PC7VQrzlrpLXHogzaXEUpyRaKjFXFScCAAzjBjkTgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 05, 2014 3:25 PM, Peter Griffin wrote:
> 
> This patch adds the ST glue logic to manage the DWC3 HC
> on STiH407 SoC family. It manages the powerdown signal,
> and configures the internal glue logic and syscfg registers.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/usb/dwc3/Kconfig   |   9 ++
>  drivers/usb/dwc3/Makefile  |   1 +
>  drivers/usb/dwc3/dwc3-st.c | 325 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 335 insertions(+)
>  create mode 100644 drivers/usb/dwc3/dwc3-st.c
> 
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 8eb996e..6c85c43 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -79,6 +79,15 @@ config USB_DWC3_KEYSTONE
>  	  Support of USB2/3 functionality in TI Keystone2 platforms.
>  	  Say 'Y' or 'M' here if you have one such device
> 
> +config USB_DWC3_ST
> +	tristate "STMicroelectronics Platforms"
> +	depends on ARCH_STI && OF
> +	default USB_DWC3_HOST
> +	help
> +	  STMicroelectronics SoCs with one DesignWare Core USB3 IP
> +	  inside (i.e. STiH407).
> +	  Say 'Y' or 'M' if you have one such device.
> +
>  comment "Debugging features"
> 
>  config USB_DWC3_DEBUG
> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> index 10ac3e7..11c9f54 100644
> --- a/drivers/usb/dwc3/Makefile
> +++ b/drivers/usb/dwc3/Makefile
> @@ -33,3 +33,4 @@ obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
>  obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
>  obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
>  obj-$(CONFIG_USB_DWC3_KEYSTONE)		+= dwc3-keystone.o
> +obj-$(CONFIG_USB_DWC3_ST)		+= dwc3-st.o
> diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
> new file mode 100644
> index 0000000..2cae9d3
> --- /dev/null
> +++ b/drivers/usb/dwc3/dwc3-st.c
> @@ -0,0 +1,325 @@
> +/**
> + * dwc3-st.c Support for dwc3 platform devices on ST Microelectronics platforms
> + *
> + * This is a small platform driver for the dwc3 to provide the glue logic
> + * to configure the controller. Tested on STi platforms.
> + *
> + * Copyright (C) 2014 Stmicroelectronics
> + *
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + * Contributors: Aymen Bouattay <aymen.bouattay@st.com>
> + *               Peter Griffin <peter.griffin@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Inspired by dwc3-omap.c and dwc3-exynos.c.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/ioport.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/delay.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>

Would you re-order these headers alphabetically?
It enhances the readability.

> +
> +#include "core.h"
> +#include "io.h"
> +
> +/* Reg glue registers */
> +#define USB2_CLKRST_CTRL 0x00
> +#define aux_clk_en(n) ((n)<<0)
> +#define sw_pipew_reset_n(n) ((n)<<4)
> +#define ext_cfg_reset_n(n) ((n)<<8)
> +#define xhci_revision(n) ((n)<<12)
> +
> +#define USB2_VBUS_MNGMNT_SEL1 0x2C
> +/*
> + * 2'b00 : Override value from Reg 0x30 is selected
> + * 2'b01 : utmiotg_vbusvalid from usb3_top top is selected
> + * 2'b10 : pipew_powerpresent from PIPEW instance is selected
> + * 2'b11 : value is 1'b0
> + */
> +#define SEL_OVERRIDE_VBUSVALID(n) ((n)<<0)
> +#define SEL_OVERRIDE_POWERPRESENT(n) ((n)<<4)
> +#define SEL_OVERRIDE_BVALID(n) ((n)<<8)
> +
> +#define USB2_VBUS_MNGMNT_VAL1 0x30
> +#define OVERRIDE_VBUSVALID_VAL (1 << 0)
> +#define OVERRIDE_POWERPRESENT_VAL (1 << 4)
> +#define OVERRIDE_BVALID_VAL (1 << 8)
> +
> +/* Static DRD configuration */
> +#define USB_HOST_DEFAULT_MASK	0xffe
> +#define USB_SET_PORT_DEVICE	0x1
> +
> +struct st_dwc3 {
> +	struct platform_device *dwc3;	/* platform device pointer */
> +	struct device *dev;	/* device pointer */
> +	void __iomem *glue_base;	/* ioaddr for programming the glue */
> +	struct regmap *regmap;	/* regmap for getting syscfg */
> +	int syscfg_reg_off;	/* usb syscfg control offset */
> +	bool drd_device_conf;	/* DRD static host/device conf */
> +	struct reset_control *rstc_pwrdn;/* Rst control for powerdown*/
> +};
> +
> +static inline u32 st_dwc3_readl(void __iomem *base, u32 offset)
> +{
> +	return readl_relaxed(base + offset);
> +}
> +
> +static inline void st_dwc3_writel(void __iomem *base, u32 offset, u32 value)
> +{
> +	writel_relaxed(value, base + offset);
> +}
> +
> +/**
> + * st_dwc3_drd_init: program the port
> + * @dwc3_data: driver private structure
> + * Description: this function is to program the port as either host or device
> + * according to the static configuration passed from devicetree.
> + * OTG and dual role are not yet supported!
> + */
> +static int st_dwc3_drd_init(struct st_dwc3 *dwc3_data)
> +{
> +	u32 val;
> +
> +	regmap_read(dwc3_data->regmap, dwc3_data->syscfg_reg_off, &val);
> +
> +	if (dwc3_data->drd_device_conf)
> +		val |= USB_SET_PORT_DEVICE;
> +	else
> +		val &= USB_HOST_DEFAULT_MASK;
> +
> +	return regmap_write(dwc3_data->regmap, dwc3_data->syscfg_reg_off, val);
> +}
> +
> +/**
> + * st_dwc3_init: init the controller via glue logic
> + * @dwc3_data: driver private structure
> + */
> +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> +{
> +	u32 reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> +
> +	reg |= aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> +	reg &= ~sw_pipew_reset_n(1);
> +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> +
> +	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1);
> +	reg |= SEL_OVERRIDE_VBUSVALID(1) | SEL_OVERRIDE_POWERPRESENT(1) |
> +	    SEL_OVERRIDE_BVALID(1);
> +	st_dwc3_writel(dwc3_data->glue_base, USB2_VBUS_MNGMNT_SEL1, reg);
> +	udelay(100);
> +
> +	reg = st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTRL);
> +	reg |= sw_pipew_reset_n(1);
> +	st_dwc3_writel(dwc3_data->glue_base, USB2_CLKRST_CTRL, reg);
> +}
> +
> +static void st_dwc3_dt_get_pdata(struct platform_device *pdev,
> +				 struct st_dwc3 *dwc3_data)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	dwc3_data->drd_device_conf =
> +	    of_property_read_bool(np, "st,dwc3-drd-device");
> +}
> +
> +/**
> + * st_dwc3_probe: main probe function
> + * @pdev: platform_device
> + * Description: this is the probe function that gets all the resources to manage
> + * the glue-logic, setup the controller and take out of powerdown.
> + */
> +static int st_dwc3_probe(struct platform_device *pdev)
> +{
> +	struct platform_device *dwc3;
> +	struct st_dwc3 *dwc3_data;
> +	struct resource *res;
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->of_node;
> +	struct regmap *regmap;
> +	int ret = 0;
> +
> +	if (!node) {
> +		dev_err(dev, "device node not found\n");
> +		return -EINVAL;
> +	}
> +
> +	dwc3_data = devm_kzalloc(dev, sizeof(*dwc3_data), GFP_KERNEL);
> +	if (!dwc3_data)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg-glue");
> +	if (!res)
> +		return -ENXIO;
> +
> +	dwc3_data->glue_base = devm_request_and_ioremap(dev, res);

Please don't use devm_request_and_ioremap() any more. It was deprecated
and will be removed from 3.17-rc1.

Please, use devm_ioremap_resource() instead.

+	dwc3_data->glue_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dwc3_data->glue_base))
+		return PTR_ERR(dwc3_data->glue_base);

> +	if (!dwc3_data->glue_base)
> +		return -EADDRNOTAVAIL;
> +
> +	regmap = syscon_regmap_lookup_by_phandle(node, "st,syscfg");
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
> +	dwc3 = platform_device_alloc("st-dwc3", PLATFORM_DEVID_AUTO);
> +	if (!dwc3) {
> +		dev_err(&pdev->dev, "couldn't allocate dwc3 device\n");
> +		return -ENOMEM;
> +	}
> +
> +	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
> +
> +	dwc3->dev.parent = &pdev->dev;
> +	dwc3->dev.dma_mask = pdev->dev.dma_mask;
> +	dwc3->dev.dma_parms = pdev->dev.dma_parms;
> +
> +	dwc3_data->dwc3 = dwc3;
> +	dwc3_data->dev = &pdev->dev;
> +	dwc3_data->regmap = regmap;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-reg");
> +	if (!res) {
> +		ret = -ENXIO;
> +		goto undo_platform_dev_alloc;
> +	}
> +
> +	dwc3_data->syscfg_reg_off = res->start;
> +
> +	dev_info(&pdev->dev, "glue-logic addr 0x%p, syscfg-reg offset 0x%x\n",
> +		 dwc3_data->glue_base, dwc3_data->syscfg_reg_off);
> +
> +	dwc3_data->rstc_pwrdn = devm_reset_control_get(dwc3_data->dev, NULL);
> +	if (IS_ERR(dwc3_data->rstc_pwrdn)) {
> +		dev_err(&pdev->dev, "could not get reset controller\n");
> +		ret = PTR_ERR(dwc3_data->rstc_pwrdn);
> +		goto undo_platform_dev_alloc;
> +	}
> +
> +	/* Manage PowerDown */
> +	reset_control_deassert(dwc3_data->rstc_pwrdn);
> +
> +	st_dwc3_dt_get_pdata(pdev, dwc3_data);
> +
> +	/* Allocate and initialize the core */
> +	ret = of_platform_populate(node, NULL, NULL, dev);
> +	if (ret) {
> +		dev_err(dev, "failed to add dwc3 core\n");
> +		goto undo_powerdown;
> +	}
> +
> +	/*
> +	 * Configure the USB port as device or host according to the static
> +	 * configuration passed from the platform.
> +	 * DRD is the only mode currently supported so this will be enhanced
> +	 * later as soon as OTG will be available.
> +	 */
> +	ret = st_dwc3_drd_init(dwc3_data);
> +	if (ret) {
> +		dev_err(dev, "st_dwc3_drd_init failed\n");
> +		goto undo_powerdown;
> +	}
> +
> +	dev_info(&pdev->dev, "configured as %s DRD\n",
> +		 dwc3_data->drd_device_conf ? "device" : "host");
> +
> +	/* ST glue logic init */
> +	st_dwc3_init(dwc3_data);
> +
> +	ret = platform_device_add_resources(dwc3_data->dwc3, pdev->resource,
> +					    pdev->num_resources);
> +	if (ret) {
> +		dev_err(&pdev->dev, "couldn't add resources to dwc3 device\n");
> +		goto undo_powerdown;
> +	}
> +
> +	ret = platform_device_add(dwc3_data->dwc3);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register dwc3 device\n");
> +		goto undo_powerdown;
> +	}
> +
> +	platform_set_drvdata(pdev, dwc3_data);
> +
> +	return 0;
> +
> +undo_powerdown:
> +	reset_control_assert(dwc3_data->rstc_pwrdn);
> +undo_platform_dev_alloc:
> +	platform_device_put(pdev);
> +
> +	return ret;
> +
> +}
> +
> +static int st_dwc3_remove(struct platform_device *pdev)
> +{
> +	struct st_dwc3 *dwc3_data = platform_get_drvdata(pdev);
> +
> +	platform_device_unregister(dwc3_data->dwc3);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int st_dwc3_suspend(struct device *dev)
> +{
> +	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
> +
> +	reset_control_assert(dwc3_data->rstc_pwrdn);
> +
> +	pinctrl_pm_select_sleep_state(dev);
> +
> +	return 0;
> +}
> +
> +static int st_dwc3_resume(struct device *dev)
> +{
> +	struct st_dwc3 *dwc3_data = dev_get_drvdata(dev);
> +
> +	pinctrl_pm_select_default_state(dev);
> +
> +	reset_control_deassert(dwc3_data->rstc_pwrdn);
> +
> +	return 0;
> +}
> +
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static const struct dev_pm_ops st_dwc3_dev_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(st_dwc3_suspend, st_dwc3_resume)
> +};
> +
> +static struct of_device_id st_dwc3_match[] = {

Please add 'const' as below. This is because all OF functions
handle of_device_id as const.

static const struct of_device_id st_dwc3_match[] = {

> +	{ .compatible = "st,stih407-dwc3" },
> +	{ /* sentinel */ },
> +};
> +
> +MODULE_DEVICE_TABLE(of, st_dwc3_match);
> +
> +static struct platform_driver st_dwc3_driver = {
> +	.probe = st_dwc3_probe,
> +	.remove = st_dwc3_remove,
> +	.driver = {
> +		.name = "usb-st-dwc3",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(st_dwc3_match),

You already use OF dependency as below. So, of_match_ptr() is
NOT necessary.

+config USB_DWC3_ST
+	tristate "STMicroelectronics Platforms"
+	depends on ARCH_STI && OF

Please remove of_match_ptr() as below.

+		.of_match_table = st_dwc3_match,


Best regards,
Jingoo Han

> +		.pm = &st_dwc3_dev_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(st_dwc3_driver);
> +
> +MODULE_AUTHOR("Giuseppe Cavallaro <peppe.cavallaro@st.com>");
> +MODULE_DESCRIPTION("DesignWare USB3 STi Glue Layer");
> +MODULE_LICENSE("GPL v2");
> --
> 1.9.1

