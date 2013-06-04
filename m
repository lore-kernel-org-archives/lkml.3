Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab3FDEG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:06:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3FDEGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:06:24 -0400
X-AuditID: cbfee68f-b7f436d000000f81-1f-51ad67bd7962
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Message-id: <51AD67CF.60300@samsung.com>
Date: Tue, 04 Jun 2013 13:06:39 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 06/10] mmc: dw_mmc-pltfm: add Rockchip variant
References: <201306030055.15413.heiko@sntech.de>
 <201306030059.03783.heiko@sntech.de>
In-reply-to: <201306030059.03783.heiko@sntech.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWyRsSkUHdv+tpAg+27dSz+TjrGbrH99UY2
	iwOzH7JaHPizg9Hi/6PXrBY3frWxWpz5rWsx5c9yJotNj6+xWlzeNYfN4sj/fkaL25d5LZ5O
	uMhmcer6ZzaLwysOMFl8uH+R2WLzpqnMDoIeLc09bB6/f01i9Fjw+Qq7x6Eraxk97lzbw+bx
	7tw5do/NS+o9zs9YyOhx5UQTq0ffllWMHtuvzWP2+LxJLoAnissmJTUnsyy1SN8ugSvj9M0l
	LAXbxCsa1p9nb2CcI9zFyMkhIWAicXXlOXYIW0ziwr31bF2MXBxCAksZJb52LWWDKZrUcwQq
	MZ1R4sHyq4wgCV4BQYkfk++xgNjMAjoS+1unsUHYIhIP2p9BxbUlli18zQzR/JJRonN9OxNE
	s4bE6b+PgRIcHCwCqhK/FseDhNmA5mz/dhysRFQgTGJTTzOYLSJgJnHrahvYHGaBxawSq960
	gy0TFnCSeNgJcamQQLjEukvrwRo4BQwl9pz4zg7SICFwhkNi/ZpWsCIWAQGJb5MPsYAslhCQ
	ldh0gBniS0mJgytusExgFJ+F5LdZSH6bheS3WUh+W8DIsopRNLUguaA4Kb3IWK84Mbe4NC9d
	Lzk/dxMjMJmc/vesfwfj3QPWhxiTgdZPZJYSTc4HJqO8knhDYzMjC1MTU2Mjc0sz0oSVxHnV
	WqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBOfmm0adO1nn8iNac//Ly4706mMdeNzd3K
	4g+Obq7Xbn1fmSN0x9iwP2ffj2N1OydLh7udebIh/W5a42mZHS5eDyJ3eOXwnTiq57X/a4/H
	XsdnL15w/5xzIE4qqLkt98wpDV2+r+HW631aS698ZORYanB7e5o1m2/G3V55ocfrG/7o5J+/
	0H9NiaU4I9FQi7moOBEA9+RMTzwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jQd296WsDDZp/KVn8nXSM3WL7641s
	FgdmP2S1OPBnB6PF/0evWS1u/GpjtTjzW9diyp/lTBabHl9jtbi8aw6bxZH//YwWty/zWjyd
	cJHN4tT1z2wWh1ccYLL4cP8is8XmTVOZHQQ9Wpp72Dx+/5rE6LHg8xV2j0NX1jJ63Lm2h83j
	3blz7B6bl9R7nJ+xkNHjyokmVo++LasYPbZfm8fs8XmTXABPVAOjTUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QZ0oKZYk5pUChgMTiYiV9O0wTQkPc
	dC1gGiN0fUOC4HqMDNBAwhrGjE/b4gumiFfcOfOSvYHxl1AXIyeHhICJxKSeI2wQtpjEhXvr
	gWwuDiGB6YwSD5ZfZQRJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAjsT+1mlQ9S8ZJTrXtzNB
	1GtInP77mBmknkVAVeLX4niQMBtQ/fZvx8FKRAXCJDb1NIPZIgJmEreutjGDzGEWWMwqsepN
	O9hBwgJOEg87l4LZQgLhEusurQdr4BQwlNhz4jv7BEaBWUjOm4Vw3iwk5y1gZF7FKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJEZx0nkntYFzZYHGIUYCDUYmHt2LbmkAh1sSy4srcQ4wSHMxK
	Iry9LmsDhXhTEiurUovy44tKc1KLDzEmAz03kVlKNDkfmBDzSuINjU3MjCyNzA0tjIzNSRNW
	Euc90GodKCSQnliSmp2aWpBaBLOFiYNTqoExTyOFb5HWA471+c+K3BkEjNUzay4Ys30R7TTz
	XaUisTpEzXYjQ0XK6WU8rI/evtqyNaVi+xnDa6fyy1rL/PewHetq+9TyfplIrNgfg4Qz7Oy7
	DsjJBgpdXyyx0LKU/cLe6Ij8Xq+8H3/qusTK5m9j57ibnSlxumL3Fnb1nnV5jK5H0n++6lFi
	Kc5INNRiLipOBAAYKxbCfgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 07:59 AM, Heiko Stübner wrote:
> Cortex-A9 SoCs from Rockchip use a slightly modified variant of dw_mmc
> controllers that seems to require the SDMMC_CMD_USE_HOLD_REG bit to
> always be set.
> 
> There also seem to be no other modifications (additional register etc)
> present, so to keep the footprint low, add this small variant to the
> pltfm driver.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/mmc/host/dw_mmc-pltfm.c |   48 +++++++++++++++++++++++++++-----------
>  1 files changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index 0048da8..7d041b5 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -24,6 +24,16 @@
>  
>  #include "dw_mmc.h"
>  
> +
> +static void dw_mci_rockchip_prepare_command(struct dw_mci *host, u32 *cmdr)
How about using "dw_mci_pltfm_prepare_command()"?
Maybe HOLD_REG could be used at other SoC.
> +{
> +	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
> +}
> +
> +static const struct dw_mci_drv_data rockchip_drv_data = {
> +	.prepare_command	= dw_mci_rockchip_prepare_command,
> +};
> +
>  int dw_mci_pltfm_register(struct platform_device *pdev,
>  				const struct dw_mci_drv_data *drv_data)
>  {
> @@ -63,20 +73,6 @@ int dw_mci_pltfm_register(struct platform_device *pdev,
>  }
>  EXPORT_SYMBOL_GPL(dw_mci_pltfm_register);
>  
> -static int dw_mci_pltfm_probe(struct platform_device *pdev)
> -{
> -	return dw_mci_pltfm_register(pdev, NULL);
> -}
> -
> -int dw_mci_pltfm_remove(struct platform_device *pdev)
> -{
> -	struct dw_mci *host = platform_get_drvdata(pdev);
> -
> -	dw_mci_remove(host);
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(dw_mci_pltfm_remove);
> -
>  #ifdef CONFIG_PM_SLEEP
>  /*
>   * TODO: we should probably disable the clock to the card in the suspend path.
> @@ -114,10 +110,34 @@ EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
>  
>  static const struct of_device_id dw_mci_pltfm_match[] = {
>  	{ .compatible = "snps,dw-mshc", },
> +	{ .compatible = "rockchip,cortex-a9-dw-mshc",
> +		.data = &rockchip_drv_data },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
>  
> +static int dw_mci_pltfm_probe(struct platform_device *pdev)
> +{
> +	const struct dw_mci_drv_data *drv_data = NULL;
> +	const struct of_device_id *match;
> +
> +	if (pdev->dev.of_node) {
> +		match = of_match_node(dw_mci_pltfm_match, pdev->dev.of_node);
> +		drv_data = match->data;
> +	}
> +
> +	return dw_mci_pltfm_register(pdev, drv_data);
> +}
> +
> +int dw_mci_pltfm_remove(struct platform_device *pdev)
> +{
> +	struct dw_mci *host = platform_get_drvdata(pdev);
> +
> +	dw_mci_remove(host);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dw_mci_pltfm_remove);
> +
>  static struct platform_driver dw_mci_pltfm_driver = {
>  	.probe		= dw_mci_pltfm_probe,
>  	.remove		= dw_mci_pltfm_remove,
> 

