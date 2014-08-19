Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaHSFIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:08:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52095 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaHSFII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:08:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f306d000003d81-8e-53f2dbb3ff61
Content-transfer-encoding: 8BIT
Message-id: <53F2DBB2.1000701@samsung.com>
Date: Tue, 19 Aug 2014 14:08:02 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        zhenfu.fang@rock-chips.com, cf@rock-chips.com, lintao@rock-chips.com,
        chenfen@rock-chips.com, zyf@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yzq@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, zhangqing@rock-chips.com,
        hl@rock-chips.com
Subject: Re: [PATCH v2] mmc: dw_mmc: move rockchip related code to a separate
 file
References: <1408003293-27375-1-git-send-email-addy.ke@rock-chips.com>
 <1408422974-22301-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1408422974-22301-1-git-send-email-addy.ke@rock-chips.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSWUwTURSGc+dOh1KCjgX0ggoBoxiiIJteoxjji8ODETeImoClTgoRS9OC
	+qISsVUQkEUFEaFlUcCCWsAS41JKCQRCaUEKKAFEI4TFoBARRbGlD/rq2znn/8/58yWHC/lD
	HA9uvDiJlYoFCT4Uj1S7hki21r37emSbXOONHyzNE1h+fYLC43fbODi7RwtwicHIwZ0Pmijc
	2l0G8c0pFQcvjU5ycMtkL4m/P2mHuF45D7FxogrgZ/kLFC6aicYqRTmJe54XUdiwdBPgij4z
	gdv7ZimcnV9D4unBfBLLXxoc8MywGeLWmiicq+Tj+7XlFH6bM2C1To1DfPXnBwKXjDTCvV6M
	/GU2xaiL1YC5l2ImmZ6sTIKpejhHMXWVfoymOo1iBi0vKOZN2xUO0z+hIphfha9JJqu+GjBa
	SzFkZjWeEStO8HafZhPiz7HSgD2neHGVphEHiZy5UNB7KQXM7kwHXC6iQ5DqenQ6cLSWq5Fp
	6DGVDnhcPl0BUNf7Vxy7EIJ+6K452IVSgJ6aKpcFZ3oV+p43RNoOQdoLGbrP2MaQ9kW5xaXQ
	7p8ESF035mDzONN+SGE5bfOQ9EZUWjC2fIaityDtt1bCVrvRkUivKCZsu650M4E6mt8vN5BW
	QrRgeUXZXC70UdTS0MaxJ6QClDm9tLzuSO9H2nEtaRMQ3e6IPpvrKHsejb7l6Uk783qk0UE7
	mjtqquwns8Hqwn+ACv8CFf4DpASwGrixEqFEFiuShvrLBGdlyWKRvzDxrAZYf6vj96ecRjCs
	26UHQmtiDvRwEyZaf0+cFBMYvD0Ih4aEBgft2Ln9/8Y+a5xFo7GH+bRIkMSeYVkJK42RJiew
	Mj0guI4eKaBkXediWPe+sLUNES53UyNLItJcwic3K2rMJzffjo/sKgvMuCM9OCD/YsxQf+WP
	hI/UqnOPfdxwcqX3PB4VR6WgXxdu3e8sPx9qzGiq9Q7S10SnHtim81zb9Vqxydd0Y6zCeVF/
	uWyqoXtO92hG4dXr5OQecOj4tfyLO/gTlt2j8i8+pCxOEOgHpTLBHzHrx6lxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xgO7m25+CDZreC1ss+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFtuk/2SzmfIizWNi2hMXi8q45bBZH/vczWiy9fpHJ4tT1z2wWE6avZbF4e2c6i0Xr
	3iPsFh/uX2S2OL423GLSAiGLueuWsFncmngTqPTNC2aLlt+PmSzmP9jB7CDv0bp3ApvHmnlr
	GD1mN1xk8bjc18vksXL5FzaPzSu0PDat6mTzuHNtD5vHlRNNrB43Xi1k8vg7az+LR9+WVYwe
	26/NY/b4vEkugC+qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zBxhQSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMFRcesBe0
	elTMuFrXwPjZsouRk0NCwETi14F2dghbTOLCvfVsXYxcHEICixglNl5YwQqS4BUQlPgx+R5L
	FyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/ZpRYs/k5O0gNr4CWRNu1FJAaFgFViUUznoONYRPQ
	kdj+7TgTiC0qECZxqG0eE0iviMBhJonThx+COcwCC5glfl7bxwZSJSwQInF06wlWiA3NjBK9
	b/+DtXMKuEtsf7GdZQKjwCwkB85COHAWkgMXMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAhOi8+kdjCubLA4xCjAwajEw6vw5WOwEGtiWXFl7iFGCQ5mJRHelVs+BQvxpiRWVqUW5ccX
	leakFh9iNAX6byKzlGhyPjBl55XEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C
	6WPi4JRqYOyatGqp0bvuLoe1l9esfPBlTW9lg+89/9d5t+d6WyvyRDye8lHk7KLjr0trEsPX
	b9p1hf/g3C3Pru37uMR/dk0mn7WB1JEbmz97bfilOT1heldTx4tDX77l9UbOlFzStf9vmYNH
	+rlFshfWHZCpnV29t+DQpii7Y0JH/HLEmXdV3ZsnOWOWncw6JZbijERDLeai4kQAQSbS0aED	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 08/19/2014 01:36 PM, Addy Ke wrote:
> To support HS200 and UHS-1, we need add a big hunk of code,
> as shown in the following patches. So a separate file for
> rockchip SOCs is suitable.
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - Kconfig: depend on ARCH_ROCKCHIP, suggested by Bartlomiej Zolnierkiewicz
> - Kconfig: depend on OF, suggested by Doug Anderson
> - Not change suspend/resume code, suggested by Doug Anderson
> - If pdev->dev.of_node is NULL, then return -ENODEV, suggested by Heiko Stübner
> 
>  drivers/mmc/host/Kconfig           |   9 +++
>  drivers/mmc/host/Makefile          |   1 +
>  drivers/mmc/host/dw_mmc-pltfm.c    |  57 ----------------
>  drivers/mmc/host/dw_mmc-rockchip.c | 136 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 146 insertions(+), 57 deletions(-)
>  create mode 100644 drivers/mmc/host/dw_mmc-rockchip.c
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index a565254..f6095f6 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -621,6 +621,15 @@ config MMC_DW_PCI
>  
>  	  If unsure, say N.
>  
> +config MMC_DW_ROCKCHIP
> +	tristate "Rockchip specific extensions for Synopsys DW Memory Card Interface"
> +	depends on MMC_DW && ARCH_ROCKCHIP && OF
> +	select MMC_DW_PLTFM
> +	help
> +	  This selects support for Rockchip SoC specific extensions to the
> +	  Synopsys DesignWare Memory Card Interface driver. Select this option
> +	  for platforms based on RK3066, RK3188 and RK3288 SoC's.
> +
>  config MMC_SH_MMCIF
>  	tristate "SuperH Internal MMCIF support"
>  	depends on MMC_BLOCK
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index 7f81ddf..5fce465 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -45,6 +45,7 @@ obj-$(CONFIG_MMC_DW_PLTFM)	+= dw_mmc-pltfm.o
>  obj-$(CONFIG_MMC_DW_EXYNOS)	+= dw_mmc-exynos.o
>  obj-$(CONFIG_MMC_DW_K3)		+= dw_mmc-k3.o
>  obj-$(CONFIG_MMC_DW_PCI)	+= dw_mmc-pci.o
> +obj-$(CONFIG_MMC_DW_ROCKCHIP)	+= dw_mmc-rockchip.o
>  obj-$(CONFIG_MMC_SH_MMCIF)	+= sh_mmcif.o
>  obj-$(CONFIG_MMC_JZ4740)	+= jz4740_mmc.o
>  obj-$(CONFIG_MMC_VUB300)	+= vub300.o
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index b547f7a..0c56c41 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -26,64 +26,11 @@
>  #include "dw_mmc.h"
>  #include "dw_mmc-pltfm.h"
>  
> -#define RK3288_CLKGEN_DIV	2
> -
>  static void dw_mci_pltfm_prepare_command(struct dw_mci *host, u32 *cmdr)
>  {
>  	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
>  }
>  
> -static int dw_mci_rk3288_setup_clock(struct dw_mci *host)
> -{
> -	host->bus_hz /= RK3288_CLKGEN_DIV;
> -
> -	return 0;
> -}
> -
> -static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
> -{
> -	int ret;
> -	unsigned int cclkin;
> -	u32 bus_hz;
> -
> -	/*
> -	 * cclkin: source clock of mmc controller.
> -	 * bus_hz: card interface clock generated by CLKGEN.
> -	 * bus_hz = cclkin / RK3288_CLKGEN_DIV;
> -	 * ios->clock = (div == 0) ? bus_hz : (bus_hz / (2 * div))
> -	 *
> -	 * Note: div can only be 0 or 1
> -	 *       if DDR50 8bit mode(only emmc work in 8bit mode),
> -	 *       div must be set 1
> -	 */
> -	if ((ios->bus_width == MMC_BUS_WIDTH_8) &&
> -	    (ios->timing == MMC_TIMING_MMC_DDR52))
> -		cclkin = 2 * ios->clock * RK3288_CLKGEN_DIV;
> -	else
> -		cclkin = ios->clock * RK3288_CLKGEN_DIV;
> -
> -	ret = clk_set_rate(host->ciu_clk, cclkin);
> -	if (ret)
> -		dev_warn(host->dev, "failed to set rate %uHz\n", ios->clock);
> -
> -	bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
> -	if (bus_hz != host->bus_hz) {
> -		host->bus_hz = bus_hz;
> -		/* force dw_mci_setup_bus() */
> -		host->current_speed = 0;
> -	}
> -}
> -
> -static const struct dw_mci_drv_data rk2928_drv_data = {
> -	.prepare_command	= dw_mci_pltfm_prepare_command,
> -};
> -
> -static const struct dw_mci_drv_data rk3288_drv_data = {
> -	.prepare_command	= dw_mci_pltfm_prepare_command,
> -	.set_ios	= dw_mci_rk3288_set_ios,
> -	.setup_clock	= dw_mci_rk3288_setup_clock,
> -};
> -
>  static const struct dw_mci_drv_data socfpga_drv_data = {
>  	.prepare_command	= dw_mci_pltfm_prepare_command,
>  };
> @@ -144,10 +91,6 @@ EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
>  
>  static const struct of_device_id dw_mci_pltfm_match[] = {
>  	{ .compatible = "snps,dw-mshc", },
> -	{ .compatible = "rockchip,rk2928-dw-mshc",
> -		.data = &rk2928_drv_data },
> -	{ .compatible = "rockchip,rk3288-dw-mshc",
> -		.data = &rk3288_drv_data },
>  	{ .compatible = "altr,socfpga-dw-mshc",
>  		.data = &socfpga_drv_data },
>  	{},
> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
> new file mode 100644
> index 0000000..f0c2cb1
> --- /dev/null
> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
> @@ -0,0 +1,136 @@
> +/*
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/mmc/host.h>
> +#include <linux/mmc/dw_mmc.h>
> +#include <linux/of_address.h>
> +
> +#include "dw_mmc.h"
> +#include "dw_mmc-pltfm.h"
> +
> +#define RK3288_CLKGEN_DIV       2
> +
> +static void dw_mci_rockchip_prepare_command(struct dw_mci *host, u32 *cmdr)
> +{
> +	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
> +}
> +
> +static int dw_mci_rk3288_setup_clock(struct dw_mci *host)
> +{
> +	host->bus_hz /= RK3288_CLKGEN_DIV;
> +
> +	return 0;
> +}
> +
> +static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
> +{
> +	int ret;
> +	unsigned int cclkin;
> +	u32 bus_hz;
> +
> +	/*
> +	 * cclkin: source clock of mmc controller
> +	 * bus_hz: card interface clock generated by CLKGEN
> +	 * bus_hz = cclkin / RK3288_CLKGEN_DIV
> +	 * ios->clock = (div == 0) ? bus_hz : (bus_hz / (2 * div))
> +	 *
> +	 * Note: div can only be 0 or 1
> +	 *       if DDR50 8bit mode(only emmc work in 8bit mode),
> +	 *       div must be set 1
> +	 */
> +	if (ios->bus_width == MMC_BUS_WIDTH_8 &&
> +	    ios->timing == MMC_TIMING_MMC_DDR52)
> +		cclkin = 2 * ios->clock * RK3288_CLKGEN_DIV;
> +	else
> +		cclkin = ios->clock * RK3288_CLKGEN_DIV;
> +
> +	ret = clk_set_rate(host->ciu_clk, cclkin);
> +	if (ret)
> +		dev_warn(host->dev, "failed to set rate %uHz\n", ios->clock);
> +
> +	bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
> +	if (bus_hz != host->bus_hz) {
> +		host->bus_hz = bus_hz;
> +		/* force dw_mci_setup_bus() */
> +		host->current_speed = 0;
> +	}
> +}
> +
> +static const struct dw_mci_drv_data rk2928_drv_data = {
> +	.prepare_command        = dw_mci_rockchip_prepare_command,
> +};
> +
> +static const struct dw_mci_drv_data rk3288_drv_data = {
> +	.prepare_command        = dw_mci_rockchip_prepare_command,
> +	.set_ios		= dw_mci_rk3288_set_ios,
> +	.setup_clock    = dw_mci_rk3288_setup_clock,
> +};
> +
> +static const struct of_device_id dw_mci_rockchip_match[] = {
> +	{ .compatible = "rockchip,rk2928-dw-mshc",
> +		.data = &rk2928_drv_data },
> +	{ .compatible = "rockchip,rk3288-dw-mshc",
> +		.data = &rk3288_drv_data },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, dw_mci_rockchip_match);
> +
> +static int dw_mci_rockchip_probe(struct platform_device *pdev)
> +{
> +	const struct dw_mci_drv_data *drv_data;
> +	const struct of_device_id *match;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	match = of_match_node(dw_mci_rockchip_match, pdev->dev.of_node);
> +	drv_data = match->data;
> +
> +	return dw_mci_pltfm_register(pdev, drv_data);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int dw_mci_rockchip_suspend(struct device *dev)
> +{
> +	struct dw_mci *host = dev_get_drvdata(dev);
> +
> +	return dw_mci_suspend(host);
> +}
> +
> +static int dw_mci_rockchip_resume(struct device *dev)
> +{
> +	struct dw_mci *host = dev_get_drvdata(dev);
> +
> +	return dw_mci_resume(host);
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static SIMPLE_DEV_PM_OPS(dw_mci_rockchip_pmops,
> +			 dw_mci_rockchip_suspend,
> +			 dw_mci_rockchip_resume);
> +
> +static struct platform_driver dw_mci_rockchip_pltfm_driver = {
> +	.probe		= dw_mci_rockchip_probe,
> +	.remove		= __exit_p(dw_mci_pltfm_remove),
> +	.driver		= {
> +		.name		= "dwmmc_rockchip",
> +		.of_match_table	= dw_mci_rockchip_match,
> +		.pm		= &dw_mci_rockchip_pmops,
> +	},
> +};
> +
> +module_platform_driver(dw_mci_rockchip_pltfm_driver);
> +
> +MODULE_AUTHOR("Addy Ke <addy.ke@rock-chips.com>");
> +MODULE_DESCRIPTION("Rockchip Specific DW-MSHC Driver Extension");
> +MODULE_ALIAS("platform:dwmmc-rockchip");
> +MODULE_LICENSE("GPL v2");
> 

