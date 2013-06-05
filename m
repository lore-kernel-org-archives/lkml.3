Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3FEOAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:00:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29564 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3FEOAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:00:45 -0400
X-AuditID: cbfee68f-b7f436d000000f81-34-51af448bef80
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "=?utf-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'John Stultz'" <john.stultz@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de>
 <201306030059.03783.heiko@sntech.de>
In-reply-to: <201306030059.03783.heiko@sntech.de>
Subject: RE: [PATCH 06/10] mmc: dw_mmc-pltfm: add Rockchip variant
Date: Wed, 05 Jun 2013 23:00:43 +0900
Message-id: <001601ce61f5$11b37b20$351a7160$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5f6nbGBfEp23v8Ss+WVOBYOTly6QB9tSlw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t8zI91ul/WBBlN2iln8nXSM3WL7641s
	FgdmP2S1OPBnB6PF/0evWS1u/GpjtTjzW9diyp/lTBabHl9jtbi8aw6bxZH//YwWty/zWjyd
	cJHN4tT1z2wWh1ccYLLYvGkqs4OAR0tzD5vH71+TGD0WfL7C7nHoylpGjzvX9rB5vDt3jt1j
	85J6j/MzFjJ6XDnRxOrRt2UVo8f2a/OYPT5vkgvgieKySUnNySxLLdK3S+DKeL6tkaXgrGTF
	tYaSBsZ20S5GTg4JAROJzYfeMULYYhIX7q1n62Lk4hASWMYosaxjEjtM0fW5HawQiemMEic6
	DzFBOH8YJdbdmsYCUsUmoCXx980bZhBbRCBO4v+txywgRcwC81kkfh2bxQSSEBIIl1h3aT2Y
	zSlgKLHnxHewFcICThK3O/YA7ebgYBFQldj1QAokzCtgK/FzUyMjhC0o8WPyPRaQEmYBdYkp
	U3JBwswC2hJP3l1gBQlLAIUf/dWFuMBI4lLXTHaIEhGJfS9AnuQCKnnCIfH41WI2kASLgIDE
	t8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIVk8C2HxLCSLZyHZsICRZRWjaGpBckFxUnqRsV5x
	Ym5xaV66XnJ+7iZGSErp38F494D1IcZkoO0TmaVEk/OBKSmvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyicqYtPyalvF+0uvzXObeSq0KKRrFc
	vC8kdkx5K+a8aUKVQERd8/6SdqM7zR7bvke4b1be9OzPnw3+U/7qxbQdlVH2k6hSEzd08D77
	f0s3q8bChhNfX8etuPzhvmn7Eq5X17aFFQu8dqiLSl3rEz1z8/6upifJIfPl7e4wTGk42n1a
	1/CkzC4lluKMREMt5qLiRAA5mAWXPwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42I5/e+xoG63y/pAg03X+S3+TjrGbrH99UY2
	iwOzH7JaHPizg9Hi/6PXrBY3frWxWpz5rWsx5c9yJotNj6+xWlzeNYfN4sj/fkaL25d5LZ5O
	uMhmcer6ZzaLwysOMFls3jSV2UHAo6W5h83j969JjB4LPl9h9zh0ZS2jx51re9g83p07x+6x
	eUm9x/kZCxk9rpxoYvXo27KK0WP7tXnMHp83yQXwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfH
	O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAPaWkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC
	1zckCK7HyAANJKxjzHi+rZGl4KxkxbWGkgbGdtEuRk4OCQETietzO1ghbDGJC/fWs3UxcnEI
	CUxnlDjReYgJwvnDKLHu1jQWkCo2AS2Jv2/eMIPYIgJxEv9vPWYBKWIWmM8i8evYLCaQhJBA
	uMS6S+vBbE4BQ4k9J76zg9jCAk4Stzv2AK3g4GARUJXY9UAKJMwrYCvxc1MjI4QtKPFj8j0W
	kBJmAXWJKVNyQcLMAtoST95dYAUJSwCFH/3VhbjASOJS10x2iBIRiX0v3jFOYBSahWTQLIRB
	s5AMmoWkYwEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4IT1THoH46oGi0OMAhyMSjy8
	Dz6tDRRiTSwrrsw9xCjBwawkwjvRYX2gEG9KYmVValF+fFFpTmrxIcZkoC8nMkuJJucDk2le
	SbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKAVPYXYOiPZGz9/8X
	0OfSYHtnXaL3z2T+rVNuLtWGp1x3sc+/teT7mytJWV0v/00p2HY25wXzTq/DJzPYVsXEvPZb
	UxEaftT2SMq+mqhJ/eyl/htXyVydt1D0h+c5qYhZru1+U/I3715x9GpqxiPOZxOi9uhvfmb5
	/kyDb9rm6JkyX9yvS37M2pOlxFKckWioxVxUnAgADzEA+JwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 7:59 AM, Heiko Stübner wrote:
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
> +{
> +	*cmdr |= SDMMC_CMD_USE_HOLD_REG;
Currently, SDMMC_CMD_USE_HOLD_REG is defined in dw_mmc-exynos.c
It should be moved to dw_mmc.h

Thanks,
Seungwon Jeon
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
> --
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

