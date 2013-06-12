Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab3FLBWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:22:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65276 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3FLBWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:22:02 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-46-51b7cd38f9f0
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "=?UTF-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'Mike Turquette'" <mturquette@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
References: <201306111328.52679.heiko@sntech.de>
 <201306111330.56901.heiko@sntech.de>
In-reply-to: <201306111330.56901.heiko@sntech.de>
Subject: RE: [PATCH v3 4/7] mmc: dw_mmc-pltfm: add Rockchip variant
Date: Wed, 12 Jun 2013 10:22:00 +0900
Message-id: <000a01ce670b$3cf651c0$b6e2f540$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5mly9NHE6vGI68QRyVS/ae//kq4QABi+tw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t8zA13Ls9sDDZbuY7R4OeEwo8XfScfY
	Lba/3shmcWD2Q1aLA392MFr8f/Sa1eLGrzZWiyl/ljNZbHp8jdXi8q45bBZH/vczWty+zGvx
	dMJFNotT1z+zWRxecYDJ4umDJiYHAY+W5h42j9+/JjF6LPh8hd3jyaaLjB47Z91l9zh0ZS2j
	x51re9g8Ni+p9zg/YyGjx5UTTawefVtWMXpsvzaP2ePzJrkA3igum5TUnMyy1CJ9uwSujImf
	NzEVNIpUfPsa0cC4R6CLkZNDQsBE4tOhWYwQtpjEhXvr2boYuTiEBJYxSvRN/cgKU/Tv7x9W
	iMQiRomXn5cwQTh/GCVetc5gB6liE9CS+PvmDTOILSIQJ/F/3nx2kCJmgR0sEle2/AAbJSQQ
	LnFh4jmwBk4BQ4nTl1cxgdjCAs4S0yZcAbNZBFQldn65D2bzCthKbP55HcoWlPgx+R4LiM0s
	oC4xad4iZghbW+LJuwtA8zmATlWXePRXF+IGI4lvm5czQpSISOx78Y4R5B4JgSccEucauxkh
	dglIfJt8iAWiV1Zi0wFmiI8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkov
	MtErTswtLs1L10vOz93ECEkyE3Yw3jtgfYgxGWj9RGYp0eR8YJLKK4k3NDYzsjA1MTU2Mrc0
	I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjtrH7pjPX/PLZ/t4y2hlivfRz
	wePbHAE+M873SYSUva+ezB5XPT9t30rrS4E809738W5dsPpRc1Hnj7g396vnlFfGMDDMlLti
	6BGh+vGa2qRHXMrqm9coCGkv2/u95jDTQ/dax0lTDe9+CFer1uWduqbThavsH8NS3ovu33Ve
	mU7JP9Rj0mmgxFKckWioxVxUnAgAY7YJmEgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsVy+t9jAV2Ls9sDDX4vsrB4OeEwo8XfScfY
	Lba/3shmcWD2Q1aLA392MFr8f/Sa1eLGrzZWiyl/ljNZbHp8jdXi8q45bBZH/vczWty+zGvx
	dMJFNotT1z+zWRxecYDJ4umDJiYHAY+W5h42j9+/JjF6LPh8hd3jyaaLjB47Z91l9zh0ZS2j
	x51re9g8Ni+p9zg/YyGjx5UTTawefVtWMXpsvzaP2ePzJrkA3qgGRpuM1MSU1CKF1Lzk/JTM
	vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoNeUFMoSc0qBQgGJxcVK+naYJoSG
	uOlawDRG6PqGBMH1GBmggYR1jBkTP29iKmgUqfj2NaKBcY9AFyMnh4SAicS/v39YIWwxiQv3
	1rN1MXJxCAksYpR4+XkJE4Tzh1HiVesMdpAqNgEtib9v3jCD2CICcRL/581nByliFtjBInFl
	yw+wUUIC4RIXJp4Da+AUMJQ4fXkVE4gtLOAsMW3CFTCbRUBVYueX+2A2r4CtxOaf16FsQYkf
	k++xgNjMAuoSk+YtYoawtSWevLsANJ8D6FR1iUd/dSFuMJL4tnk5I0SJiMS+F+8YJzAKzUIy
	aRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAU9kx6B+OqBotDjAIc
	jEo8vAfMtgcKsSaWFVfmHmKU4GBWEuHVzQUK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w
	veaVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+M87qL3ypIs
	rjWfApP9WdXXBpgI73JLSslsEVkpK8weUr2PP7Wx/G5jiLh/aaXn2088H7IX+p4vkDq3bfaG
	/9piD/7JW/uZL2US/eKgbSmUYnr7rNVDrZ1zzn4/c+nQ86/sTMWnF/JwMzlkqUWmKPwvzJ/b
	wXxd7YbKVyOdg9nV1iLMJSu4lViKMxINtZiLihMB8+IJ+KUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.
But this patch has a dependency on '[PATCH 2/2] mmc: dw_mmc: Add support DW SD/MMC driver on SOCFPGA'
After that, it can be applied.(SDMMC_CMD_USE_HOLD_REG should be moved in dw_mmc.h)

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

On 06/11/13 2013 8:31 PM Heiko Stübner wrote:
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
>  drivers/mmc/host/dw_mmc-pltfm.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index 9b05381..cbbbcf3 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -24,6 +24,15 @@
> 
>  #include "dw_mmc.h"
> 
> +static void dw_mci_rockchip_prepare_command(struct dw_mci *host, u32 *cmdr)
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
> @@ -100,13 +109,23 @@ EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
> 
>  static const struct of_device_id dw_mci_pltfm_match[] = {
>  	{ .compatible = "snps,dw-mshc", },
> +	{ .compatible = "rockchip,cortex-a9-dw-mshc",
> +		.data = &rockchip_drv_data },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
> 
>  static int dw_mci_pltfm_probe(struct platform_device *pdev)
>  {
> -	return dw_mci_pltfm_register(pdev, NULL);
> +	const struct dw_mci_drv_data *drv_data = NULL;
> +	const struct of_device_id *match;
> +
> +	if (pdev->dev.of_node) {
> +		match = of_match_node(dw_mci_pltfm_match, pdev->dev.of_node);
> +		drv_data = match->data;
> +	}
> +
> +	return dw_mci_pltfm_register(pdev, drv_data);
>  }
> 
>  int dw_mci_pltfm_remove(struct platform_device *pdev)
> --
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

