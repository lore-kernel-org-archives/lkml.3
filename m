Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbaLBXPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:15:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64093 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933162AbaLBXPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:15:36 -0500
X-AuditID: cbfee68e-f79b46d000002b74-df-547e481592bf
Message-id: <547E4815.7010100@samsung.com>
Date: Wed, 03 Dec 2014 08:15:33 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, tony@atomide.com,
        linux@arm.linux.org.uk, chris@printf.net, gsoutade@neotion.com,
        axel.lin@ingics.com, s.hauer@pengutronix.de, wsa@the-dreams.de,
        joe@perches.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mmc: core: Support the optional init_card()
 callback for MMC and SD
References: <1417553397-460-1-git-send-email-dianders@chromium.org>
 <1417553397-460-2-git-send-email-dianders@chromium.org>
In-reply-to: <1417553397-460-2-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42JZI2JSoivqURdi0PhTw2Ll+7+MFg/mbWOz
	ODLnK7PFhMvbGS3OLjvIZjG7fxqzxf9Hr1ktZt9/zGKx6fE1VovLu+YA1f3vZ7SYvaSfxeL2
	ZV6Lv9s3sVg8OTOT0eLD/YvMFvuveFkcXxtusfLELGYHYY+W5h42j29fJ7F4zG64yOLR9rPM
	4861PWwem5fUexzbJuHR/9fA48uqa8weN14tZPLo27KK0WP7tXnMHidPPWHx+LxJLoAvissm
	JTUnsyy1SN8ugSvjxJ9bzAXTZCum7O5jb2D8K9bFyMkhIWAisbXtNjOELSZx4d56NhBbSGAp
	o8Sq44kwNa++/mDvYuQCii9ilGj6d4Qdoug1o8SFTe4gNq+AlsTVufOZQGwWAVWJ7w/es4DY
	bAI6Etu/HQeLiwqESRxqm8cEUS8o8WPyPbAaEYFyiTlbe5hAFjALHGaWWLZnH1iRsECixOtz
	HVDLaiV+bPkC1sAp4CLxcu1LsDgz0IL9rdPYIGx5ic1r3jKDDJIQuMEhcaJ7OQvERQIS3yYf
	ArI5gBKyEpsOQH0sKXFwxQ2WCYxis5DcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKRXnJhbXJqX
	rpecn7uJEZg6Tv971reD8eYB60OMAhyMSjy8J87XhAixJpYVV+YeYjQFumIis5Rocj4wQeWV
	xBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBYcZi7Nit+
	pfuPFG0lXdmbkdZ/F9Q6sThsnPpEyYbRW47vftDfe29SJt++HKF4ZkVul6Kyq8K7F+rz0mcJ
	3C/rWy0UV54ftEJ2ZcaMJXJb1R5XCSmvk58oFb/SNlF2YaJmofoFJSWBE5JOtQ/Y59+4ckDH
	d2v2+eXvbrDIBhkJn1qauFE/+IwSS3FGoqEWc1FxIgBnejtkGAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAV1Rj7oQgxVb5SxWvv/LaPFg3jY2
	iyNzvjJbTLi8ndHi7LKDbBaz+6cxW/x/9JrVYvb9xywWmx5fY7W4vGsOUN3/fkaL2Uv6WSxu
	X+a1+Lt9E4vFkzMzGS0+3L/IbLH/ipfF8bXhFitPzGJ2EPZoae5h8/j2dRKLx+yGiywebT/L
	PO5c28PmsXlJvcexbRIe/X8NPL6susbscePVQiaPvi2rGD22X5vH7HHy1BMWj8+b5AL4ohoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZpz4c4u5YJpsxZTdfewNjH/Fuhg5
	OSQETCReff3BDmGLSVy4t56ti5GLQ0hgEaNE078jYAkhgdeMEhc2uYPYvAJaElfnzmcCsVkE
	VCW+P3jPAmKzCehIbP92HCwuKhAmcahtHhNEvaDEj8n3wGpEBMol5mztYQJZwCxwmFli2Z59
	YEXCAokSr891QC2rlfix5QtYA6eAi8TLtS/B4sxAC/a3TmODsOUlNq95yzyBUWAWkh2zkJTN
	QlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwanomtYNxZYPFIUYBDkYlHt6PcnUh
	QqyJZcWVuYcYJTiYlUR48+yAQrwpiZVVqUX58UWlOanFhxhNgUEwkVlKNDkfmDbzSuINjU3M
	jCyNzA0tjIzNlcR5b9zMDRESSE8sSc1OTS1ILYLpY+LglGpg5K67/KkgKZJT78/JEK6crV/c
	VnJf4bnk3msbtfVTT1Lwyn2L26Sjrv8PjOcN5D4vMyfg+yTOoC5HtzyZZYd8/JJn7lv+8vni
	4tTDbmUC06Z1lW6e4Zy31ddoXnHD20n33723u83i2tl8w2WOYN68+F3aZesjW63OaS/+deTG
	9zfb3s2sndXHr8RSnJFoqMVcVJwIAOEAG1JjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug.

I think good that this patch is separated to two patches.
(board file and codes relevant to mmc.)

Best Regards,
Jaehoon Chung

On 12/03/2014 05:49 AM, Doug Anderson wrote:
> In (3fcb027 ARM: MXC: mxcmmc: work around a bug in the SDHC busy line
> handling) the optional init_card() callback was added.  According to
> the original change it was "for now only called from
> mmc_sdio_init_card()".
> 
> This callback really ought to be called from the SD and MMC init
> functions as well.  One current user of this callback
> (mxcmci_init_card) will not work as expected if you insert an SDIO
> card, then eject it and put a normal SD card in.  Specifically the
> normal SD card will not get to run with 4-bit data.
> 
> I'd like to use the init_card() callback to handle a similar quirk on
> dw_mmc when using SDIO Interrupts (the "low power" feature of the card
> needs to be disabled), so that will add a second user of the function.
> 
> As part of this change fixup the one place that relied on the callback
> only happening for SDIO cards.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> ---
> Changes in v3:
> - Add fixup to pandora_wl1251_init_card().
> 
> Changes in v2:
> - mmc core change new for this version.
> 
>  arch/arm/mach-omap2/board-omap3pandora.c | 14 ++++++++------
>  drivers/mmc/core/mmc.c                   |  6 ++++++
>  drivers/mmc/core/sd.c                    |  7 ++++++-
>  3 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
> index 7f17087..969e100 100644
> --- a/arch/arm/mach-omap2/board-omap3pandora.c
> +++ b/arch/arm/mach-omap2/board-omap3pandora.c
> @@ -254,12 +254,14 @@ static void pandora_wl1251_init_card(struct mmc_card *card)
>  	 * We have TI wl1251 attached to MMC3. Pass this information to
>  	 * SDIO core because it can't be probed by normal methods.
>  	 */
> -	card->quirks |= MMC_QUIRK_NONSTD_SDIO;
> -	card->cccr.wide_bus = 1;
> -	card->cis.vendor = 0x104c;
> -	card->cis.device = 0x9066;
> -	card->cis.blksize = 512;
> -	card->cis.max_dtr = 20000000;
> +	if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
> +		card->quirks |= MMC_QUIRK_NONSTD_SDIO;
> +		card->cccr.wide_bus = 1;
> +		card->cis.vendor = 0x104c;
> +		card->cis.device = 0x9066;
> +		card->cis.blksize = 512;
> +		card->cis.max_dtr = 20000000;
> +	}
>  }
>  
>  static struct omap2_hsmmc_info omap3pandora_mmc[] = {
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 02ad792..4a21d66 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -1297,6 +1297,12 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>  	}
>  
>  	/*
> +	 * Call the optional HC's init_card function to handle quirks.
> +	 */
> +	if (host->ops->init_card)
> +		host->ops->init_card(host, card);
> +
> +	/*
>  	 * For native busses:  set card RCA and quit open drain mode.
>  	 */
>  	if (!mmc_host_is_spi(host)) {
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index d90a6de..29fccdc 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -933,6 +933,12 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
>  	}
>  
>  	/*
> +	 * Call the optional HC's init_card function to handle quirks.
> +	 */
> +	if (host->ops->init_card)
> +		host->ops->init_card(host, card);
> +
> +	/*
>  	 * For native busses:  get card RCA and quit open drain mode.
>  	 */
>  	if (!mmc_host_is_spi(host)) {
> @@ -1271,4 +1277,3 @@ err:
>  
>  	return err;
>  }
> -
> 

