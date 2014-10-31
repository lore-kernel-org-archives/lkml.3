Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbaJaIpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:45:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47984 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaJaIpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:45:15 -0400
X-AuditID: cbfee68f-f791c6d000004834-1e-54534c171e35
Message-id: <54534C17.7050703@samsung.com>
Date: Fri, 31 Oct 2014 17:45:11 +0900
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
Subject: Re: [PATCH v2] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
 <1414727409-6765-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1414727409-6765-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjuO985x6lZx5X6JXRbF8jKNC+9UURE1An6EWlFF7NlB7OmyaZS
	9COR1sUuakKrmbrltGWaNU0tW9rQtCuaNU3sZnZhGqSGOqzW2Vbgv+fled7neV54JVjaxQRK
	EpJSBGWSXCFjveiyqeGqxQEbo6JDDMeDoMQxQoH6lI2Fb5dbGMhur0FQ2PiCgeclD1loflmE
	Iatfz4Cjp4+Bpr7XNIzeeoKhSjeC4YXtOoJqjZ2FKz92g+mTlQH9CQMN7feusNDoyEIw+MGB
	obijjYInHUMsZGvKafjeraFBbW70gN5nlxH8eN+Gobl8G1zQSSH/poGFrpw3or7/G4bjY58o
	KPxQi1fLeLU5m+XLCsoQn5feRvPt589R/PVrP1m+0hjEm0pPs3y39b44GY7xr1oyGL7Tpqf4
	39p6mj9fVYr4GmsB5odMMzZN3uG1cp+gSEgTlEtW7fHaX/F0kEk2Lzj8uTOfTUdfZmUiTwnh
	wklv0w3ajf1J67sKNhN5SaRcMSJ6hwb/F5X0PEJu4ioid4y1lHvoQ6T1rsbDqfLhgojeWMw6
	Mc3NI0O5RsqJWW4RqRludmE/biuxnCig3HpfMpr7zhU9leuiiKFjrdMUc/2Y9HQNuIgp4sLF
	wge0Oy0DkTp7pquTJ7eOVNRpXWlYTKhXX/yHZ5LKsu/YuUA4qyc501vt4a7EkeFci+gkEYnp
	xNTw77Zp5KGxk85G/tpxpbTjbLXjbHUIlyI/ITkuWbU3XhkWrJInqlKT4oPjDiWakPhyT/98
	yapFbxtWWBAnQbKJPrrmzdFSRp6mOpJoQRFiixwc6Bd3SPzSpJTY0LDIpRARHhG2dNnySFmA
	jz7QHiXl4uUpwkFBSBaUscpUhaCyIEriGZiOpq/ZWb/6aHrPrLOTmwbUX6NOPki8oQndF79r
	4WKd91e7uuLaxphoSFiv9lbMm8n6bJ/zOmOw75f5+cec/DkpWyuDx+QN1XkQu0V6u2iDPVpr
	1ekOjBTZcg11s+ebNsd4DDyyjV2iPz57HDB326k/m8o/H243F07wraKpjgshLZNAIaNV++Wh
	QVipkv8FXW4iEW0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsVy+t9jAV1xn+AQgz2TZS2W/f/OZNHa8YrN
	4sXME6wWEy5vZ7SYf+Qcq8XZZQfZLI5fWsxs0f9mIavF/0evWS2Ovr7KYvFjwylmiy0LvjNb
	nHu1ktFi2/SfbBZzPsRZbHp8jdViYdsSFovLu+awWRz5389o8enBf2aLpdcvMlmcuv6ZzWLC
	9LUsFm/vTGexaN17hN3iyZmZjBYf7l9ktji+Ntxi0gIhi7nrlrBZ3Jp4E6j+zQtmi5bfj5ks
	5j/Yweyg5NG6dwKbx5p5axg9ZjdcZPG43NfL5LFy+Rc2j80rtDw2repk87hzbQ+Qt6Te48qJ
	JlaPG68WMnn8nbWfxaNvyypGj+3X5jF7fN4kF8Af1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMOyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYQ1jxvrTn1gL9mpWPL0xl62B8ZlCFyMnh4SAicSyR8cYIWwxiQv31rN1MXJx
	CAksYpTYumIHE4TzmlHiws7p7CBVvAJaEgtXLGUDsVkEVCU+T17BBGKzCehIbP92HMwWFQiT
	ONQ2jwmiXlDix+R7LCC2iMAtJokl111AhjILvGGWeHTrI1hCGKhh2vx9LBDbmhgldv/sYgZJ
	cAq4SazfPQtsGzPQhv2t06BseYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJEZxCn0nvYFzVYHGIUYCDUYmHd8HxoBAh1sSy4srcQ4wSHMxKIrwi7sEh
	QrwpiZVVqUX58UWlOanFhxhNgWEwkVlKNDkfmN7zSuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJ
	pCeWpGanphakFsH0MXFwSjUwyqntYVl5R4qrb6LbG8c1eRk/HQRsf1y+Gle66FWCX+B/Z3dz
	vajlh38em/0zV7bx8HqfdzeubP94d8FKFmF9Fw9T5ycTP3CGXp88gZ8zM5v9yhQ7PZE/xzqm
	aUw2Ck/4W7JL7PO3Oa8FtbW1PB4fun7/y7cW/Zyv8kdUpT2DP/Oychf26IWUKLEUZyQaajEX
	FScCAKdQI2W3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

On 10/31/2014 12:50 PM, Addy Ke wrote:
> The bit of sdio interrupt is 16 in designware implementation,
> but it is 24 in RK3288. This patch add sdio_id0 for the number
> of slot0 in the SDIO interrupt registers, which can be set in
> platform DT table, such as:
> - rockchip,sdio-interrupt-slot0 = <8>;

I have a question. (It's not important question)
You mentioned the sdio-irq bit used from 24 to 31, right?
Then what interrupts are used from 16 to 23 at RK3288? Just reserved?

Best Regards,
Jaehoon Chung

> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next branch
> 
>  drivers/mmc/host/dw_mmc-rockchip.c | 13 +++++++++++++
>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>  drivers/mmc/host/dw_mmc.h          |  2 ++
>  include/linux/mmc/dw_mmc.h         |  3 +++
>  4 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
> index bbb4ec3..1cb3bc6 100644
> --- a/drivers/mmc/host/dw_mmc-rockchip.c
> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
> @@ -68,6 +68,18 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>  	}
>  }
>  
> +static int dw_mci_rk3288_parse_dt(struct dw_mci *host)
> +{
> +	struct device_node *np = host->dev->of_node;
> +	int sdio_id0;
> +
> +	if (!of_property_read_u32(np, "rockchip,sdio-interrupt-slot0",
> +				  &sdio_id0))
> +		host->sdio_id0 = sdio_id0;
> +
> +	return 0;
> +}
> +
>  static const struct dw_mci_drv_data rk2928_drv_data = {
>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>  };
> @@ -76,6 +88,7 @@ static const struct dw_mci_drv_data rk3288_drv_data = {
>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>  	.set_ios		= dw_mci_rk3288_set_ios,
>  	.setup_clock    = dw_mci_rk3288_setup_clock,
> +	.parse_dt	= dw_mci_rk3288_parse_dt,
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

