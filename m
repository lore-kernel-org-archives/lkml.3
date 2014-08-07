Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbaHGIr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:47:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45416 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaHGIru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:47:50 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-d0-53e33d2af77c
Message-id: <53E33D2A.7030109@samsung.com>
Date: Thu, 07 Aug 2014 17:47:38 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        jh80.chung@samsung.com, chris@printf.net, ulf.hansson@linaro.org,
        dinguyen@altera.com, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        zhenfu.fang@rock-chips.com, cf@rock-chips.com, lintao@rock-chips.com,
        chenfen@rock-chips.com, zyf@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yzq@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, zhangqing@rock-chips.com,
        hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add support for RK3288
References: <1404963109-3906-1-git-send-email-addy.ke@rock-chips.com>
 <1406786498-3935-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1406786498-3935-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTcRjG+59zdtoM5TRv/4ysDAksTcv0la4UxSkiomBBUDbtoOJlc1sX
	P2RLmpWkmV3MNW/ldc6yWRqVt6FN7UJmTUvRcmVeQdK8hdnmCvzatx/v+7zP83x4+aTQzHPj
	R8QoOFmMOMqDtqN0Tv5Sb68t5kO+9QUroGB2ggDVpQEa+jIaeZDaWokgu/4ND14X1NFgfHeP
	hKtDuTyY7RnkQcPgBwomy5pJeJQzQcKbgWIE7dOJPKhIn6JBM3IMchPzKGh9qqGhfvYqgvy2
	FgKa20ZpSE0vpWC4M50CVVX9QhjpbiHBWHoY0nKEkHk/j4ZP1z5apEN9JFz4ZSYg+/MTcvsK
	VlWVSrO6LB1i7yhbKLY1JZlgiwvHaLa8yIvVay/TbKfpOc2+b0zgse0DuQQ7o66h2JRHWsRW
	mrJIdlTvfsDhiN3mE1xUxClOtm7rcbvwb5oiJO3wPNP9+AehRHnuSUjAx4w/bivsWmhjF/y2
	6wFtZSGTj/D33jX/NCkpFcg2T0d4qMIhCdlZeBDhZ6bblmM+357xwsrOWKuGYjzx67qsOU+a
	WYsrx42ElZ0ZETYkZs2xPbMYT17voqzsxHQQWH/R1epJMjkknjJVz5VwZADnF34mbGHnEdY0
	9fCsCwGzGzdkZM4lkJaEGtUt2sbLcblumLS1bhbgTj1ja8Tg8esGyloUM8uwvvavZAmuK2qn
	UpGLel4n9TxX9TzXHERqkTMnDZXKQ8Jkfj5ycbT8ZEyYT6gkWo8sD/byd2/yE9RRu8mAQi2R
	10g351CJ5QFjFMF+GwLWw0b/jRvWBwYF/N/Yw9U+5EvIQSETJlZwkRwn5WTBspNRnNyACL7A
	TYlu7KuS+DEJfSbvVknSNFbEqbnDd3ft+eQjjy/rN54rMdPuvgv2xmnjVaLqhqbqfUtzjwq/
	7jy9P7a6YJXuwDGHfoOktObViysjosiViqOCsYe+JZAY9EAZX2KmjIrkWdgRqFhUViNfHZss
	yj67xbUCO27LuJhWHjgTXhnxc/FND0oeLvbzImVy8R+K25XndgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsVy+t9jQV0t28fBBicfiVgs+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFjV9trBbbpv9ks5jzIc5iYdsSFovLu+awWRz5389osfT6RSaLU9c/s1lMmL6WxeLt
	neksFq17j7BbfLh/kdni+Npwi0kLhCzmrlvCZnFr4k2g0jcvmC1afj9mspj/YAezg4JH694J
	bB5r5q1h9JjdcJHF43JfL5PHyuVf2Dw2r9Dy2LSqk83jzrU9bB5XTjSxetx4tZDJ4++s/Swe
	fVtWMXpsvzaP2ePzJrkAvqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcYGgpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOe
	zlnBWHBbteL+1k9MDYxL5LoYOTkkBEwk+vq2MULYYhIX7q1nA7GFBKYzSrzZxtfFyAVkv2aU
	2H1tBnsXIwcHr4CWRMOdQpAaFgFVibMH57GD2GwCOhLbvx1nArFFBcIkDrXNA7N5BQQlfky+
	xwJiiwjcZpLY1C4OMpNZYAGzxM9r+8CWCQtYSCxd/oAJYlkjo8Sck49YQRKcAm4SR2fOBdvA
	DLRhf+s0NghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBKfIZ9I7GFc1WBxiFOBgVOLhtWx6FCzEmlhWXJl7iFGCg1lJhLfa+nGwEG9KYmVValF+
	fFFpTmrxIUZTYBhMZJYSTc4Hpu+8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWp
	RTB9TBycUg2M7uotd+ZZHGLSt/U6883n6A3NG575K0SO1WQyVfodvHW+Z/Vcj2gnt3Vys8uu
	pirOuObsJuxy7d3W7z92i05z9ArXvKq69OX7H4yiuUU+vyb7PHo35U/6so4dsdvWPp0orhl7
	Yg6nWk6e4IVbCZlvvQT4qqz5a57cu7KhyGVDcEONf+TS6EnzlViKMxINtZiLihMBS+143acD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 07/31/2014 03:01 PM, Addy Ke wrote:
> This patch focuses on clock setting for RK3288 mmc controller.
> 
> In RK3288 mmc controller, CLKDIV register can only be set 0 or 1,
> and if DDR 8bit mode, CLKDIV register must be set 1.
> 
> Reported-by Doug Anderson <dianders@chromium.org>
> Suggested-by: Jaehoon Chung <jh80.chung@samsung.com>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> changes since v1:
> - dw_mci_rk3288_setup_clock: do not call clk_get_rate(), just use the
>   host->bus_hz which is already called by dw_mmc.c, suggested by Jaehoon Chung
> 
> changes since v2:
> - merge from ChromiumOS tree, fix up clock settting bug, 
>   which cause DDR50 mode for emmc not to work, reported by Doug Anderson
> - remove MMC_TIMING_UHS_DDR50 condition, because on RK3288 only emmc can work
>   in 8bit mode, suggested by Doug Anderson
> 
>  .../devicetree/bindings/mmc/rockchip-dw-mshc.txt   |  6 ++-
>  drivers/mmc/host/dw_mmc-pltfm.c                    | 56 +++++++++++++++++++++-
>  2 files changed, 58 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
> index c559f3f..c327c2d 100644
> --- a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
> @@ -10,12 +10,14 @@ extensions to the Synopsys Designware Mobile Storage Host Controller.
>  Required Properties:
>  
>  * compatible: should be
> -	- "rockchip,rk2928-dw-mshc": for Rockchip RK2928 and following
> +	- "rockchip,rk2928-dw-mshc": for Rockchip RK2928 and following,
> +							before RK3288
> +	- "rockchip,rk3288-dw-mshc": for Rockchip RK3288
>  
>  Example:
>  
>  	rkdwmmc0@12200000 {
> -		compatible = "rockchip,rk2928-dw-mshc";
> +		compatible = "rockchip,rk3288-dw-mshc";
>  		reg = <0x12200000 0x1000>;
>  		interrupts = <0 75 0>;
>  		#address-cells = <1>;
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index d4a47a9..b547f7a 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -21,17 +21,67 @@
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/dw_mmc.h>
>  #include <linux/of.h>
> +#include <linux/clk.h>
>  
>  #include "dw_mmc.h"
>  #include "dw_mmc-pltfm.h"
>  
> +#define RK3288_CLKGEN_DIV	2
> +
>  static void dw_mci_pltfm_prepare_command(struct dw_mci *host, u32 *cmdr)
>  {
>  	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
>  }
>  
> -static const struct dw_mci_drv_data rockchip_drv_data = {
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
> +	 * cclkin: source clock of mmc controller.
> +	 * bus_hz: card interface clock generated by CLKGEN.
> +	 * bus_hz = cclkin / RK3288_CLKGEN_DIV;
> +	 * ios->clock = (div == 0) ? bus_hz : (bus_hz / (2 * div))
> +	 *
> +	 * Note: div can only be 0 or 1
> +	 *       if DDR50 8bit mode(only emmc work in 8bit mode),
> +	 *       div must be set 1
> +	 */
> +	if ((ios->bus_width == MMC_BUS_WIDTH_8) &&
> +	    (ios->timing == MMC_TIMING_MMC_DDR52))
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
> +	.prepare_command	= dw_mci_pltfm_prepare_command,
> +};
> +
> +static const struct dw_mci_drv_data rk3288_drv_data = {
>  	.prepare_command	= dw_mci_pltfm_prepare_command,
> +	.set_ios	= dw_mci_rk3288_set_ios,
> +	.setup_clock	= dw_mci_rk3288_setup_clock,
>  };
>  
>  static const struct dw_mci_drv_data socfpga_drv_data = {
> @@ -95,7 +145,9 @@ EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
>  static const struct of_device_id dw_mci_pltfm_match[] = {
>  	{ .compatible = "snps,dw-mshc", },
>  	{ .compatible = "rockchip,rk2928-dw-mshc",
> -		.data = &rockchip_drv_data },
> +		.data = &rk2928_drv_data },
> +	{ .compatible = "rockchip,rk3288-dw-mshc",
> +		.data = &rk3288_drv_data },
>  	{ .compatible = "altr,socfpga-dw-mshc",
>  		.data = &socfpga_drv_data },
>  	{},
> 

