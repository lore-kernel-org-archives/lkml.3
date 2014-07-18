Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbaGRCKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:10:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49841 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaGRCKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:10:30 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-21-53c8820ef20d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andy Gross'" <agross@codeaurora.org>, "'Felipe Balbi'" <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Kumar Gala'" <galak@codeaurora.org>, jackp@codeaurora.org,
        linux-arm-msm@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
 <1404144233-17222-2-git-send-email-agross@codeaurora.org>
In-reply-to: <1404144233-17222-2-git-send-email-agross@codeaurora.org>
Subject: Re: [Patch v7 1/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Date: Fri, 18 Jul 2014 11:10:21 +0900
Message-id: <005001cfa22d$6df8be80$49ea3b80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+UfTZOWtDKnobxT/GCLrIpc9ExawNrdiQg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zQ12+phPBBh++81rs/NDNZHHwfr1F
	/5uFrBbPJj5ktGh/foHN4vLCS6wWmx5fY7WYuP8su8XlXXPYLBYta2V24PK43NfL5LF5Sb3H
	pv3TmD36tqxi9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZ0zaxF0w2q9h7ZjZzA+M67S5G
	Dg4JAROJTau1uhg5gUwxiQv31rN1MXJxCAksY5Rofv2JESJhInFm7lFGiMQiRokjLU3MEM5v
	RonXq+ayg1SxCahJfPlyGMwWEXCXWLh6EztIEbNAH5PEvbaFYAkhgUZGibuTrUBsTgE3id2/
	JrCC2MICXhIXG/aB2SwCqhJX1qwBq+cVsJWY/gJkG4gtKPFj8j0WEJtZQEti/c7jTBC2vMTm
	NW+ZId5Rl3j0VxfiBiOJN//uQ5WISOx78Q7sAwmBRg6JX8t2sUHsEpD4NvkQC0SvrMSmA8wQ
	H0tKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kR
	EuF9OxhvHrA+xJgMtH4is5Rocj4wQeSVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBsbiuDmHj3cw5SVVcLS4mzEceaxQs+Pkp6LwmrrAK7c4LJXV
	I86v7fhRkPvxcPAO9d1CfvHLXH8u4F53VahhoV1/Sca1M/F/srSjYmY0np/ttL5h0tv5Oy7N
	tVjzYSvXrk41i4f//MNkZr0PmPh+2+pJBxesZzpmumDPlcWus13XSzLs59i9xrdNiaU4I9FQ
	i7moOBEA0zxDbAYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAV2+phPBBlPfcFjs/NDNZHHwfr1F
	/5uFrBbPJj5ktGh/foHN4vLCS6wWmx5fY7WYuP8su8XlXXPYLBYta2V24PK43NfL5LF5Sb3H
	pv3TmD36tqxi9Dh+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYM6ZtYi+YbFax98xs5gbGddpdjJwcEgImEmfmHmWEsMUkLtxbz9bFyMUhJLCIUeJISxMz
	hPObUeL1qrnsIFVsAmoSX74cBrNFBNwlFq7exA5SxCzQxyRxr20hWEJIoJFR4u5kKxCbU8BN
	YvevCawgtrCAl8TFhn1gNouAqsSVNWvA6nkFbCWmvwDZBmILSvyYfI8FxGYW0JJYv/M4E4Qt
	L7F5zVugGg6gU9UlHv3VhbjBSOLNv/tQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCE8gzqR2MKxssDjEKcDAq8fBa3DweLMSaWFZcmXuI
	UYKDWUmEN/s+UIg3JbGyKrUoP76oNCe1+BCjKdCjE5mlRJPzgcktryTe0NjEzMjSyMzCyMTc
	XEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDY7LD4+UvVylKp++Zdn7NIuaKtJrL7UG23+ft
	fXH80JxbMYWvlZ3z/BSn8WU8n1j5eGK7XOvZVuYVHYHM+WEr/rYGLrmtn1xb/0HRmeP6w15/
	Q2tZ04ufNhV7CgZom39NPDWt9srjrUaHRdOX5a5TnFBg9O/qEokORu7UxhqZ4PsP9ukubInb
	o8RSnJFoqMVcVJwIABQCcAU2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2014 1:04 AM, Felipe Balbi wrote:
> 
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> DWC3 glue layer is hardware layer around Synopsys DesignWare
> USB3 core. Its purpose is to supply Synopsys IP with required
> clocks, voltages and interface it with the rest of the SoC.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/usb/dwc3/Kconfig     |    9 +++
>  drivers/usb/dwc3/Makefile    |    1 +
>  drivers/usb/dwc3/dwc3-qcom.c |  153 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 163 insertions(+)
>  create mode 100644 drivers/usb/dwc3/dwc3-qcom.c
> 
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 8eb996e..29fcbfd 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -79,6 +79,15 @@ config USB_DWC3_KEYSTONE
>  	  Support of USB2/3 functionality in TI Keystone2 platforms.
>  	  Say 'Y' or 'M' here if you have one such device
> 
> +config USB_DWC3_QCOM
> +       tristate "Qualcomm Platforms"
> +       default USB_DWC3

How about adding the machine dependency? Ex. ARCH_QCOM?
Currently, other dwc3 glue layers are using ARCH_* dependency.


> +       select USB_QCOM_DWC3_PHY
> +       help
> +         Recent Qualcomm SoCs ship with one DesignWare Core USB3 IP inside,
> +         say 'Y' or 'M' if you have one such device.
> +
> +

Please remove an unnecessary line. One line is enough.

>  comment "Debugging features"
> 
>  config USB_DWC3_DEBUG
> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> index 10ac3e7..0da8e75 100644
> --- a/drivers/usb/dwc3/Makefile
> +++ b/drivers/usb/dwc3/Makefile
> @@ -33,3 +33,4 @@ obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
>  obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
>  obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
>  obj-$(CONFIG_USB_DWC3_KEYSTONE)		+= dwc3-keystone.o
> +obj-$(CONFIG_USB_DWC3_QCOM)		+= dwc3-qcom.o
> diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
> new file mode 100644
> index 0000000..e99764a
> --- /dev/null
> +++ b/drivers/usb/dwc3/dwc3-qcom.c
> @@ -0,0 +1,153 @@
> +/* Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/usb/phy.h>
> +
> +#include "core.h"
> +
> +

Please remove an unnecessary line. One line is enough.

> +struct dwc3_qcom {
> +	struct device		*dev;
> +
> +	struct clk		*core_clk;
> +	struct clk		*iface_clk;
> +	struct clk		*sleep_clk;
> +
> +	struct regulator	*gdsc;
> +};
> +
> +static int dwc3_qcom_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct dwc3_qcom *qdwc;
> +	int ret = 0;
> +
> +	qdwc = devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
> +	if (!qdwc)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, qdwc);
> +
> +	qdwc->dev = &pdev->dev;
> +
> +	qdwc->gdsc = devm_regulator_get(qdwc->dev, "gdsc");
> +
> +	qdwc->core_clk = devm_clk_get(qdwc->dev, "core");
> +	if (IS_ERR(qdwc->core_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get core clock\n");
> +		return PTR_ERR(qdwc->core_clk);
> +	}
> +
> +	qdwc->iface_clk = devm_clk_get(qdwc->dev, "iface");
> +	if (IS_ERR(qdwc->iface_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get iface clock, skipping\n");
> +		qdwc->iface_clk = NULL;
> +	}
> +
> +	qdwc->sleep_clk = devm_clk_get(qdwc->dev, "sleep");
> +	if (IS_ERR(qdwc->sleep_clk)) {
> +		dev_dbg(qdwc->dev, "failed to get sleep clock, skipping\n");
> +		qdwc->sleep_clk = NULL;
> +	}
> +
> +	if (!IS_ERR(qdwc->gdsc)) {
> +		ret = regulator_enable(qdwc->gdsc);
> +		if (ret)
> +			dev_err(qdwc->dev, "cannot enable gdsc\n");
> +	}
> +
> +	clk_prepare_enable(qdwc->core_clk);
> +
> +	if (qdwc->iface_clk)
> +		clk_prepare_enable(qdwc->iface_clk);
> +
> +	if (qdwc->sleep_clk)
> +		clk_prepare_enable(qdwc->sleep_clk);
> +
> +	ret = of_platform_populate(node, NULL, NULL, qdwc->dev);
> +	if (ret) {
> +		dev_err(qdwc->dev, "failed to register core - %d\n", ret);
> +		dev_dbg(qdwc->dev, "failed to add create dwc3 core\n");

Is there any reason to use two similar messages?
For me, it looks duplicated.

> +		goto dis_clks;
> +	}
> +
> +	return 0;
> +
> +dis_clks:
> +	if (qdwc->sleep_clk)
> +		clk_disable_unprepare(qdwc->sleep_clk);
> +
> +	if (qdwc->iface_clk)
> +		clk_disable_unprepare(qdwc->iface_clk);
> +
> +	clk_disable_unprepare(qdwc->core_clk);
> +
> +	if (!IS_ERR(qdwc->gdsc)) {
> +		ret = regulator_disable(qdwc->gdsc);
> +		if (ret)
> +			dev_dbg(qdwc->dev, "cannot disable gdsc\n");
> +	}
> +
> +	return ret;
> +}
> +
> +static int dwc3_qcom_remove(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +
> +	struct dwc3_qcom *qdwc = platform_get_drvdata(pdev);
> +
> +	if (qdwc->sleep_clk)
> +		clk_disable_unprepare(qdwc->sleep_clk);
> +
> +	if (qdwc->iface_clk)
> +		clk_disable_unprepare(qdwc->iface_clk);
> +
> +	clk_disable_unprepare(qdwc->core_clk);
> +
> +	if (!IS_ERR(qdwc->gdsc)) {
> +		ret = regulator_disable(qdwc->gdsc);
> +		if (ret)
> +			dev_dbg(qdwc->dev, "cannot disable gdsc\n");
> +	}
> +	return ret;
> +}
> +
> +static const struct of_device_id of_dwc3_match[] = {
> +	{ .compatible = "qcom,dwc3" },
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, of_dwc3_match);
> +
> +static struct platform_driver dwc3_qcom_driver = {
> +	.probe		= dwc3_qcom_probe,
> +	.remove		= dwc3_qcom_remove,
> +	.driver		= {
> +		.name	= "qcom-dwc3",
> +		.owner	= THIS_MODULE,
> +		.of_match_table	= of_dwc3_match,
> +	},
> +};
> +
> +module_platform_driver(dwc3_qcom_driver);
> +
> +MODULE_ALIAS("platform:qcom-dwc3");

How about adding the module author as Ivan T. Ivanov and you?

MODULE_AUTHOR("Ivan T. Ivanov <iivanov@mm-sol.com>");
MODULE_AUTHOR("Andy Gross <agross@codeaurora.org>");

Best regards,
Jingoo Han

> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("DesignWare USB3 QCOM Glue Layer");
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation

