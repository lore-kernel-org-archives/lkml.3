Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaGGCHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 22:07:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54841 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaGGCHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 22:07:12 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-66-53ba00cdc017
Message-id: <53BA00CC.2090707@samsung.com>
Date: Mon, 07 Jul 2014 11:07:08 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: addy ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        hj@rock-chips.com, kever.yang@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yzq@rock-chips.com,
        zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, lintao@rock-chips.com,
        chenfen@rock-chips.com, zyf@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add support for RK3288.
References: <1404565174-2923-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1404565174-2923-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSa0hTYRjHfc85O24D6bS8vBopmhJIWV57xe5UnOxLF9DQzKYeVJwXNq2+
	CGJO1PAO3tCpeB/emua8ZJopM8WRznTmvKCksikIhhqhaxcCv/bt/zzP//39nxceNs6bYzmw
	YxOSGWECX+BCcolWax/RpSmL/qdXxg6tUKP+AEPiLC2JtsrHWahAJQeoelTJQoqZOhzlb9ey
	kH5Nx0Jjuu8EOuycwFF3zQGOlNoWgHpKf5OocvcFqs2sJ5Cqv5JEo/p8gBrmpzE0Mb9HooLS
	NgLtaEoJJB4ctUS7K9M4UrQFo6IaHqpqryfRj8IFg3V7C0cZf9YxVL3ai99ypMWDBSTdKmkF
	tCovF6Nbmn6RdFezOy2TZpO0Zu4jSc+Op7NotbYWo48qhgg6r1sKaPmcBKf3ZI6PrEK416IY
	QewrRnj5xktuTPXyEpakdHpTVsVPA3L7HMBhQ8oHaoYaCLO2hd+WO8gcwGXzqAYAd2Rr4J9p
	U6MD5kEpgAu7q4S50AG4P5nNMrqsKHdYUn1g0gTlButnc01YkroI5fsKzKhtqCA4kinBzP7T
	8LB42QSypqQYVOyl48YCpyQ4nM3qNGWfofzhkFZtIvGoe7B8VmGZA9hsDnUfzmz5G9u4IWBI
	XEKatRPsat0xcSDVwYHFX9SkeSMK7hePEMa3kDoHZcO4+Wv28HOzmigAthUndqo4ga04ga0B
	uBTYMEmRSaKIaKGvh4gfL0pJiPaITIyXAcNNTR5vFPaCleGAERBpiCzEHWwiEw03l5Ac7unt
	54V8fXy9va76+/1f28XOKnot4gmPiuYnM3EMk8QIw4UpAkY0AjA2xyENxFjEQbes1+rUwGPB
	nargskNBSNRKxlJjka9YsvbzYVOnd5Xr9fPqmCDeQF6AM1ef9ylTrJxYOQrj9LBtpc6Lqcq+
	HDv9TVV5V2hi7dfgBZ93U8TtQA/5qY1tqSslWgLri5y7H9Im+862a5ffe23Wu73VDNRdkDx7
	nPsgtDjsuQshiuF7uuNCEf8vwxOSZWkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xoO5Zhl3BBlMeM1ks+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5VovjlxYzW/S/Wchq8f/Ra1aLo6+vslj82HCK2WLLgu/MFuderWS0
	2Db9J5vFnA9xFgvblrBYXN41h83iyP9+Roul1y8yWZy6/pnNYsL0tSwWb+9MZ7Fo3XuE3eLD
	/YvMFsfXhltMWiBkMXfdEjaLWxNvApW+ecFs0fIb6Jr5D3YwO8h5tO6dwOaxZt4aRo/Lfb1M
	HiuXf2Hz2LxCy2PTqk42jzvX9rB5XDnRxOpx49VCJo+/s/azePRtWcXosf3aPGaPz5vkAnij
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DBo6RQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMmH/vLlPBOfmKGXMTGxi3S3Yx
	cnJICJhIPL/zmhHCFpO4cG89WxcjF4eQwHRGiZsfHrBAOK8ZJb6d7mQFqeIV0JKYNv87mM0i
	oCqx5EovC4jNJqAjsf3bcSYQW1QgTOJQ2zwmiHpBiR+T74ENEhFYxSRx/HMTM4jDLDCPWeJK
	xwaw3cIClhL7X90AmyQk4Cox88px9i5GDg5OATeJSy8sQcLMQAv2t05jg7DlJTavecs8gVFg
	FpIds5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBJ8Jr2DcVWDxSFGAQ5G
	JR7eA6t2BguxJpYVV+YeYpTgYFYS4T3jBhTiTUmsrEotyo8vKs1JLT7EaAoMgonMUqLJ+cAE
	nVcSb2hsYmZkaWRuaGFkbK4kznuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgVE3rF5fZf9mPcXv
	ARtezvhTs+TVti6GzK0z3lpkdy45xL72+ZzU7uvZ6lvfHwyvWD73TZCW5uSdGavk5q+Zf8Sl
	7k9R0rcbK0Nead1vevxcQc9HYbUUC//t2SERzL/6DFd9+O1XLppknvlswlKXbtFV9eJhnoce
	Hts9f+fOLVZqzccML10UFv6gxFKckWioxVxUnAgAu8V94ZgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy,

On 07/05/2014 09:59 PM, addy ke wrote:
> This patch focuses on clock setting for RK3288 mmc controller.
> 
> In RK3288 mmc controller, CLKDIV register can only be set 0 or 1,
> and if DDR 8bit mode, CLKDIV register must be set 1.
> 
> Signed-off-by: addy ke <addy.ke@rock-chips.com>
> ---
>  .../devicetree/bindings/mmc/rockchip-dw-mshc.txt   |  4 +-
>  drivers/mmc/host/dw_mmc-pltfm.c                    | 50 +++++++++++++++++++++-
>  2 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
> index c559f3f..e3f95cd 100644
> --- a/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.txt
> @@ -10,7 +10,9 @@ extensions to the Synopsys Designware Mobile Storage Host Controller.
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
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index d4a47a9..15d796e 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -21,17 +21,61 @@
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/dw_mmc.h>
>  #include <linux/of.h>
> +#include <linux/clk.h>
>  
>  #include "dw_mmc.h"
>  #include "dw_mmc-pltfm.h"
>  
> +#define RK3288_CLKGEN_DIV	2
"2" is used to the general div value at rockchip?

> +
>  static void dw_mci_pltfm_prepare_command(struct dw_mci *host, u32 *cmdr)
>  {
>  	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
>  }
>  
> -static const struct dw_mci_drv_data rockchip_drv_data = {
> +static int dw_mci_rk3288_setup_clock(struct dw_mci *host)
> +{
> +	host->bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
I knew that you need not to call clk_get_rate(). In dw-mmc.c, it's already called.
So you can just use the host->bus_hz.

host->bus_hz /= RK3288_CLKGEN_DIV;

Best Regards,
Jaehoon Chung

> +
> +	return 0;
> +}
> +
> +static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
> +{
> +	int ret;
> +	unsigned int cclkin;
> +
> +	/*
> +	 * cclkin: source clock of mmc controller.
> +	 * bus_hz: card interface clock generated by CLKGEN.
> +	 * bus_hz = cclkin / RK3288_CLKGEN_DIV;
> +	 * ios->clock = (div == 0) ? bus_hz : (bus_hz / (2 * div))
> +	 *
> +	 * Note: div can only be 0 or 1
> +	 *       if DDR50 8bit mode, div must be set 1
> +	 */
> +	if ((ios->bus_width == MMC_BUS_WIDTH_8) &&
> +	    (ios->timing == MMC_TIMING_UHS_DDR50 ||
> +	     ios->timing == MMC_TIMING_MMC_DDR52))
> +		cclkin = 2 * ios->clock * RK3288_CLKGEN_DIV;
> +	else
> +		cclkin = ios->clock * RK3288_CLKGEN_DIV;
> +
> +	ret = clk_set_rate(host->ciu_clk, cclkin);
> +	if (ret)
> +		dev_warn(host->dev, "failed to set rate %uHz\n", ios->clock);
> +
> +	host->bus_hz = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
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
> @@ -95,7 +139,9 @@ EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
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

