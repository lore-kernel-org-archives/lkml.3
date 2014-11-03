Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaKCJAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:00:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17072 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaKCJAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:00:21 -0500
X-AuditID: cbfee68e-f79b46d000002b74-82-5457440f2574
Message-id: <5457440E.3070002@samsung.com>
Date: Mon, 03 Nov 2014 17:59:58 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        jh80.chung@samsung.com, chris@printf.net, ulf.hansson@linaro.org,
        dinguyen@altera.com, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, sonnyrao@chromium.org
Cc: huangtao@rock-chips.com, devicetree@vger.kernel.org, hl@rock-chips.com,
        linux-doc@vger.kernel.org, yzq@rock-chips.com, zyw@rock-chips.com,
        zhangqing@rock-chips.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kever.yang@rock-chips.com,
        lintao@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, zhenfu.fang@rock-chips.com, chenfen@rock-chips.com,
        cf@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, zyf@rock-chips.com
Subject: Re: [PATCH v3] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
 <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf0yMcRjf9/2+79vdTbydyteZX5FN8qtfHmPGGO/4A2O1selOXok65y6G
	zaTVkVFXUTpJUalbYUfOrNTdslolUq6QNEKrtFuZIuS9u2z993n2fH492yPB8m5GIYlRxwta
	tSrWj5XRZd4h8UunbYrYvSLDNhWKx0coSL7Qx0JvTj0DhlYLgpu1zQw8L7ayUPfqNoa0gQIG
	xj/2M/Cs/zUNo/cbMDzMH8HQ3FeKoOOXnoFH2T9ZyHXsA/MnOwMF+kIaWp/kslA7noZgqHsc
	Q1F7CwUN7cMsGLLLafjWmU1DclWtB/Q05SBwfGjBUFceARn5crhxt5CFt+lvRP5AL4aksU8U
	3Ox+jNcv4JOrDCxflleG+OsJLTTfmnqZ4kvvfGf5ByUBvNmUwvKd9kpxKjzLt9UnMnxHXwHF
	/zFW03zqQxPiLfY8zA+b5+yYtke29oAQG3NC0C5fp5QdSr9ygdXoF58cai9mElDFvItIKiFc
	CBm4noXd2Je87LrHXkQyiZwrQqTCcYn6T7J9P8e4F9mIVPe+93AP/Yicd+QyTpYnF0AGP191
	WdGcP7nzKMfDiVkukFh+1LmcfLhwYtPnUW6+FxnN7KKdRt7cEEWMhiZXBOb6MGk6n+lSTxcV
	STWjE6USEfnQPuZaSLnNpHGsiHViLEZUJ2dN4LnkQdk37BQQrktK/vwd9HB34siPTJuYJxEX
	s4m5ZuLqmcRa0kEbkK9xUivjJFvjJNt8hE3IR9BEaXT7o7VBy3SqON1xdfSyqKNxZiQ+XuPf
	L6mP0ZuaNTbESZDfFE+NJXy3nFGd0J2Ks6FQsUU6VvhEHRV/VR0fuTI4LAhCQ0KDg1atDvOb
	4alU/Nwl56JV8cIRQdAI2kjt8VhBZ0OURKpIQGf6lwsGb9OLp2n2bdK9ysZBS2fPhrCd6o8D
	i8pXvFgcxS2Zp7wsrPM/7Kh0vMtbWCFTSgKTsr6mbJ+lVADbNly/5epdr6qUnIMLAvVbrcfa
	TNUBR67cWn0t7rdXRnBlZeT8rT1W37CGaF+8Mfft/rZbqcqQ3sSR0Rq7dceB0oRjp/1o3SHV
	ygCs1an+AV7ZgtRzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsVy+t9jQV1+l/AQg5tLGS2W/f/OZNHa8YrN
	4sXME6wWEy5vZ7SYf+Qcq8XZZQfZLI5fWsxs0f9mIavF/0evWS2Ovr7KYvFjwylmiy0LvjNb
	nHu1ktHixq82Vott03+yWcz5EGex6fE1VouFbUtYLC7vmsNmceR/P6PFpwf/mS2WXr/IZHHq
	+mc2iwnT17JYvL0zncWide8RdosnZ2YyWny4f5HZ4vjacItJC4Qs5q5bwmZxa+JNoPo3L5gt
	Wn4/ZrKY/2AHs4OyR+veCWwea+atYfSY3XCRxeNyXy+Tx8rlX9g8Nq/Q8ti0qpPN4861PUDe
	knqPKyeaWD1uvFrI5PF31n4Wj74tqxg9tl+bx+zxeZNcAH9UA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDjAAlRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZE6d0sBW0aVZ8ur6MtYFxq0IXIyeHhICJxKEvjawQtpjEhXvr
	2boYuTiEBKYzSux/cZcdwnnNKNH+YQ5YFa+AlsS7p1OZQWwWAVWJ5dtmsoPYbAI6Etu/HWcC
	sUUFwiQOtc1jgqgXlPgx+R4LyCARgU9MErMmnGEFcZgFXjFLnGmfDNYtDNTRcuAH1O4mRon7
	13+DJTgF3CRO/17KBmIzA63Y3zoNypaX2LzmLfMERoFZSLbMQlI2C0nZAkbmVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjB6fSZ9A7GVQ0WhxgFOBiVeHgLtoeFCLEmlhVX5h5ilOBgVhLh
	7dEJDxHiTUmsrEotyo8vKs1JLT7EaAoMhInMUqLJ+cBUn1cSb2hsYmZkaWRuaGFkbK4kznuw
	1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgdHj+NRtMmoPqqaedeT/LNXYdiX0t+utjc+0Jt+oavfR
	SjmhZj/v5Cn2N/orJSMm6O86KBKy8XTCEsZrJml/GW30NLfkXS9R7w3NPppx5dyC/08ZNYOX
	XPiX9ilK+ec8zd27JTaJi/8p7jN2XWnp/Tit7+6Vh3f/Hda185v62zfRQnzZzoeb1aYpsRRn
	JBpqMRcVJwIAK9MfTr0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

On 11/03/2014 10:20 AM, Addy Ke wrote:
> The bit of sdio interrupt is 16 in designware implementation,
> but it is 24 on Rockchip SoCs.This patch add sdio_id0 for the
> number of slot0 in the SDIO interrupt registers.
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next branch
> Changes in v3:
> - Remove dts for sdio_id0, just replace this with 8, suggested by Doug
> - Change to support all Rockchip Socs, suggested by Heiko
> 
>  drivers/mmc/host/dw_mmc-rockchip.c | 10 ++++++++++
>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>  drivers/mmc/host/dw_mmc.h          |  2 ++
>  include/linux/mmc/dw_mmc.h         |  3 +++
>  4 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
> index bbb4ec3..b997c8f 100644
> --- a/drivers/mmc/host/dw_mmc-rockchip.c
> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
> @@ -68,14 +68,24 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>  	}
>  }
>  
> +static int dw_mci_rockchip_parse_dt(struct dw_mci *host)
> +{
> +	/* It is slot 8 on Rockchip SoCs */
> +	host->sdio_id0 = 8;
> +
> +	return 0;
> +}

Well, function is "__parse_dt__", but this function don't parse anything.
If All rockchip soc is supported, i think that it can be located to other place.

Best Regards,
Jaehoon Chung

> +
>  static const struct dw_mci_drv_data rk2928_drv_data = {
>  	.prepare_command        = dw_mci_rockchip_prepare_command,
> +	.parse_dt	= dw_mci_rockchip_parse_dt,
>  };
>  
>  static const struct dw_mci_drv_data rk3288_drv_data = {
>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>  	.set_ios		= dw_mci_rk3288_set_ios,
>  	.setup_clock    = dw_mci_rk3288_setup_clock,
> +	.parse_dt	= dw_mci_rockchip_parse_dt,
>  };
>  
>  static const struct of_device_id dw_mci_rockchip_match[] = {
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index bb46b1b..a633b58 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -823,7 +823,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  
>  		/* enable clock; only low power if no SDIO */
>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
> +		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>  		mci_writel(host, CLKENA, clk_en_a);
>  
> @@ -1184,10 +1184,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  		dw_mci_disable_low_power(slot);
>  
>  		mci_writel(host, INTMASK,
> -			   (int_mask | SDMMC_INT_SDIO(slot->id)));
> +			   (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
>  	} else {
>  		mci_writel(host, INTMASK,
> -			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
> +			   (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
>  	}
>  }
>  
> @@ -2056,8 +2056,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  		/* Handle SDIO Interrupts */
>  		for (i = 0; i < host->num_slots; i++) {
>  			struct dw_mci_slot *slot = host->slot[i];
> -			if (pending & SDMMC_INT_SDIO(i)) {
> -				mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
> +			if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
> +				mci_writel(host, RINTSTS,
> +					   SDMMC_INT_SDIO(slot->sdio_id));
>  				mmc_signal_sdio_irq(slot->mmc);
>  			}
>  		}
> @@ -2145,6 +2146,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  
>  	slot = mmc_priv(mmc);
>  	slot->id = id;
> +	slot->sdio_id = host->sdio_id0 + id;
>  	slot->mmc = mmc;
>  	slot->host = host;
>  	host->slot[id] = slot;
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 71d4995..0562f10 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>   *	with CONFIG_MMC_CLKGATE.
>   * @flags: Random state bits associated with the slot.
>   * @id: Number of this slot.
> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>   */
>  struct dw_mci_slot {
>  	struct mmc_host		*mmc;
> @@ -233,6 +234,7 @@ struct dw_mci_slot {
>  #define DW_MMC_CARD_PRESENT	0
>  #define DW_MMC_CARD_NEED_INIT	1
>  	int			id;
> +	int			sdio_id;
>  };
>  
>  struct dw_mci_tuning_data {
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 69d0814..72c319f 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -96,6 +96,7 @@ struct mmc_data;
>   * @quirks: Set of quirks that apply to specific versions of the IP.
>   * @irq_flags: The flags to be passed to request_irq.
>   * @irq: The irq value to be passed to request_irq.
> + * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
>   *
>   * Locking
>   * =======
> @@ -191,6 +192,8 @@ struct dw_mci {
>  	bool			vqmmc_enabled;
>  	unsigned long		irq_flags; /* IRQ flags */
>  	int			irq;
> +
> +	int			sdio_id0;
>  };
>  
>  /* DMA ops for Internal/External DMAC interface */
> 

