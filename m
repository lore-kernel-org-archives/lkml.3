Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaJ3Ef0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:35:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45220 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaJ3EfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:35:22 -0400
X-AuditID: cbfee68f-f791c6d000004834-e3-5451c005d085
Message-id: <5451C004.3050806@samsung.com>
Date: Thu, 30 Oct 2014 13:35:16 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add a quirk for the defferent bit of sdio
 interrupt
References: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxNcRjH/c7vnOPcJo6b8nMntrvVWt570eNl2JjOH0YmZf0htzrSVHJv
	NTabNDVl6tKqKXrTTbUit1YJc12XXhAplURJ6q4XS5k06rovbP33fZ7n+3z2fbaHw9JuRsZF
	RMeKymhFpJy1oyuWeZ1ex+gO+m+8UOsCJaZpCpIujbBgvN7EgLq9DkG+oZWBVyVPWGh8ewtD
	+lghA6aBUQaejb6j4VdVC4aagmkMrSNlCGqzZ1i4MXEUtF86GShMLqahveEGCwZTOoLJfhMG
	TVcbBS1dUyyosytpGO/NpiHpkWEhDL68jmCirw1DY2UgXCuQws07xSz0XH1v9o8ZMVz8/YWC
	/P56vEsuJD1Ss0JFXgUSchPaaKE97QollN3+wQrVpe6CtjyFFXo7H5qr4vNCR1MiI3SPFFLC
	bM5jWkirKUdCXWceFqa0q/yWBNltDxMjI+JF5YYdx+xOFH2opWJyXc5oUk1sAup1TkUSjvBe
	ZEg9Rdu0E3nz6S6biuw4Ka9BJNnQv/C/Ka8vk7ENihB5MPnxXzGKyOC9Eeu6Pe9OWjqeUxZN
	8y6kwNCKLJrl15K6n43WviMfQPTJeZTNv5T8yvhk3V3G91CkuGuPBYr5MUwGer5bBw58IBme
	7rdqKb+XdFzINUM5TsL7km9vlJY2NvMfJ2WxNr2aVFeMYwuH8D0SMt3cyNoC8eRnhp627BLe
	mWh12HbZCvKktJtWI6eceZFy5mFz5mELEC5HjmJMaIwqJFzpuV6liFLFRYevDz0VpUXmh3sx
	N5Rejz7qtukRzyH5IntjqJ+/lFHEq85G6ZG3OcVVLHMMPWX+0ejY4E2emz3A28vb08Nny2b5
	cvtC2cwhKR+uiBVPimKMqAxWxkWKKj2iOIksAWmHPDVuifedNU8lEfKGVbM4bX+V7oPWUD/T
	HLIgbueusfPD+9y4yRTXA9s/Ox1ZuXdudyA1+zX+Zrnz1IKq5zjK52RAStC465+aZ9rMxLk+
	B51BssIt0OV4GM0dNk6gbyEZWWvOdTh9Pj4oGO/4Gl1lT2v8wzwcBOby64DFW2dWymnVCcUm
	d6xUKf4CIQOKbmsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsVy+t9jAV3WA4EhBus+iVss+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFtuk/2SzmfIiz2PT4GqvFwrYlLBaXd81hszjyv5/R4tOD/8wWS69fZLI4df0zm8WE
	6WtZLN7emc5i0br3CLvFkzMzGS0+3L/IbHF8bbjFpAVCFnPXLWGzuDXxJlD9mxfMFi2/HzNZ
	zH+wg9lByaN17wQ2jzXz1jB6zG64yOJxua+XyWPl8i9sHptXaHlsWtXJ5nHn2h4gb0m9x5UT
	TaweN14tZPL4O2s/i0ffllWMHtuvzWP2+LxJLoA/qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwcYdkoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjEW3tzEVzFatWNr1n62B8Y5sFyMnh4SAicS8+1NZIWwxiQv31rN1MXJx
	CAksYpTY/ekuK4TzmlHiycZXLCBVvAJaEqeuHGMCsVkEVCUWHDnHCGKzCehIbP92HCwuKhAm
	cahtHhNEvaDEj8n3wHpFBG4xSSy57gIylFngDbPEo1sfwRLCAuESz78/ALOFBNwkrjTOBhrK
	wcEp4C7x7kIRSJgZaP7+1mlsELa8xOY1b5knMArMQrJiFpKyWUjKFjAyr2IUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQITp/PpHYwrmywOMQowMGoxMP7IjkgRIg1say4MvcQowQHs5IIr0hH
	YIgQb0piZVVqUX58UWlOavEhRlNgCExklhJNzgem9rySeENjEzMjSyNzQwsjY3Mlcd4DrdaB
	QgLpiSWp2ampBalFMH1MHJxSDYxyVoK9c/mdVp7mmP9AKnFlqdfp1s4XjgsEruQKmZw1eNZq
	oXWt4t0liVvVKrvXZDMd2xHzKPtc4jkJM48bWuv4Ir/qhvUFL66xexTSd7nmS9h3Q1/GeWtd
	NJ/FldW1Lj3G9vj/0eenLGadv99497VBzb6jbzjeNKQ7PzzZ3SxhUjDpiuBrM10lluKMREMt
	5qLiRABqiA1VtQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

On 10/30/2014 11:21 AM, Addy Ke wrote:
> This patch add a quirk: DW_MCI_QUIRK_SDIO_INT_24BIT.
> 
> The bit of sdio interrupt is 16 in designware implementation, but
> is 24 in RK3288. To support RK3288 mmc controller, we need add
> a quirk for it.
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/host/dw_mmc.c  | 32 +++++++++++++++++++++++++++-----
>  drivers/mmc/host/dw_mmc.h  |  1 +
>  include/linux/mmc/dw_mmc.h |  2 ++
>  3 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..db29621 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -778,6 +778,12 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  	u32 div;
>  	u32 clk_en_a;
>  	u32 sdmmc_cmd_bits = SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT;
> +	u32 sdio_int_bit;
> +
> +	if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)

I want to change the quirk naming.
If rockchip may use the other bit for sdio_int in future,
then you need to add the DW_MCI_QUIRK_SDIO_INT_xxBIT.?

How about DW_MCI_BROKEN_SDIO_INT_BIT?
And Could you consider to control with more general method than now?


Best Regards,
Jaehoon Chung

> +		sdio_int_bit = SDMMC_INT_SDIO_24BIT(slot->id);
> +	else
> +		sdio_int_bit = SDMMC_INT_SDIO(slot->id);
>  
>  	/* We must continue to set bit 28 in CMD until the change is complete */
>  	if (host->state == STATE_WAITING_CMD11_DONE)
> @@ -819,7 +825,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  
>  		/* enable clock; only low power if no SDIO */
>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
> +		if (!(mci_readl(host, INTMASK) & sdio_int_bit))
>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>  		mci_writel(host, CLKENA, clk_en_a);
>  
> @@ -1167,6 +1173,12 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  	struct dw_mci_slot *slot = mmc_priv(mmc);
>  	struct dw_mci *host = slot->host;
>  	u32 int_mask;
> +	u32 sdio_int_bit;
> +
> +	if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)
> +		sdio_int_bit = SDMMC_INT_SDIO_24BIT(slot->id);
> +	else
> +		sdio_int_bit = SDMMC_INT_SDIO(slot->id);
>  
>  	/* Enable/disable Slot Specific SDIO interrupt */
>  	int_mask = mci_readl(host, INTMASK);
> @@ -1180,10 +1192,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  		dw_mci_disable_low_power(slot);
>  
>  		mci_writel(host, INTMASK,
> -			   (int_mask | SDMMC_INT_SDIO(slot->id)));
> +			   (int_mask | sdio_int_bit));
>  	} else {
>  		mci_writel(host, INTMASK,
> -			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
> +			   (int_mask & ~sdio_int_bit));
>  	}
>  }
>  
> @@ -2035,8 +2047,15 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  		/* Handle SDIO Interrupts */
>  		for (i = 0; i < host->num_slots; i++) {
>  			struct dw_mci_slot *slot = host->slot[i];
> -			if (pending & SDMMC_INT_SDIO(i)) {
> -				mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
> +			u32 sdio_int_bit;
> +
> +			if (host->quirks & DW_MCI_QUIRK_SDIO_INT_24BIT)
> +				sdio_int_bit = SDMMC_INT_SDIO_24BIT(i);
> +			else
> +				sdio_int_bit = SDMMC_INT_SDIO(i);
> +
> +			if (pending & sdio_int_bit) {
> +				mci_writel(host, RINTSTS, sdio_int_bit);
>  				mmc_signal_sdio_irq(slot->mmc);
>  			}
>  		}
> @@ -2452,6 +2471,9 @@ static struct dw_mci_of_quirks {
>  	}, {
>  		.quirk	= "disable-wp",
>  		.id	= DW_MCI_QUIRK_NO_WRITE_PROTECT,
> +	}, {
> +		.quirk	= "sdio-int-24bit",
> +		.id	= DW_MCI_QUIRK_SDIO_INT_24BIT,
>  	},
>  };
>  
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 01b99e8..6a48015 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -92,6 +92,7 @@
>  #define SDMMC_CTYPE_4BIT		BIT(0)
>  #define SDMMC_CTYPE_1BIT		0
>  /* Interrupt status & mask register defines */
> +#define SDMMC_INT_SDIO_24BIT(n)		BIT(24 + (n))
>  #define SDMMC_INT_SDIO(n)		BIT(16 + (n))
>  #define SDMMC_INT_EBE			BIT(15)
>  #define SDMMC_INT_ACD			BIT(14)
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 0013669..6d4669e 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -217,6 +217,8 @@ struct dw_mci_dma_ops {
>  #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
>  /* No write protect */
>  #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
> +/* In RK3288, the bit of sdio interrupt is 24 */
> +#define DW_MCI_QUIRK_SDIO_INT_24BIT		BIT(5)
>  
>  /* Slot level quirks */
>  /* This slot has no write protect */
> 

