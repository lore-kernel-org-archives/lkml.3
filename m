Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbaJ3LCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:02:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31048 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaJ3LCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:02:05 -0400
X-AuditID: cbfee68e-f79b46d000002b74-c3-54521aaa77bb
Message-id: <54521AA9.2030700@samsung.com>
Date: Thu, 30 Oct 2014 20:02:01 +0900
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
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
 <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+5//OaczSTottX+DtIyspIt5640i+lB4gj5URkFQOvVgkTe2
	KRWkUjrMUGdB4lLz1m3Nillp4XVY2jJzaaaV96hwM0zLLlprFwK//R7eh+d9Xng5LO1nZNzx
	BJWoSJDH+bJutN4jWLVeJ9t/IOD2Ix+4bvtBQWbWGAufC9sY0HTVILja0sHAi+vNLLS+qsCQ
	Zy1jwDZiYeCJ5TUNP++ZMNwv/YGhY+wWgt7fagYeFvxioWjiKBhGexgoU1fS0PW4iIUWWx6C
	ySEbhmtvzBSY3kyxoCmoomH8fQENmfUt8+FDeyGCiUEzhtaqQ3CxVArFdypZeJvfZ/dbP2PI
	mBml4OpQLd6xUsis17CCvkSPhCvpZlroys2hhFs3vrFC9U1/waA7zwrve+rsqjJN6G47ywi9
	Y2WU8EfbSAu593VIqOkpwcKUwXvvwsNu22LEuOMpomLj9ki3Y9mdMUnn15yc0K9NRz0+2UjC
	ET6YZE2ZkYu9SOfAXTYbuXFS/hoi1skc9N9UbsvGrkE5Iqa8WdolLIh01w/TDpc770+eZfyZ
	72CaX0UKGx4zDmb5daRmupVysCd/kBjVJZTLv4j8vDTgDPLgJymi1bQzDoF5KyYjb786Uxfz
	4SRrRutkKX8Okfw7iQ6W8GFkcDbf2Q/bNzRmXmZd7EOq9ePOroQfkJDxlxW0qxJPpi8Z7czZ
	B8uIoQm7bltKmm/20hrkpZ1TSjsnVjsnthRhHfIUk6KTlFGxisANSnm8MjkhdkN0YrwB2b/u
	+d+PubWor2mrEfEc8l3gvqZt3wEpI09Rnoo3ohB7i3ws84xOtD9qgipiU1BoIIQEhwQFbt4S
	6rvEPVL2K1zKx8pV4glRTBIVEYrkOFFpRBQnkaUjzno5vKkh56KirbETSR+88zYXV1da+iPS
	TA8P7Ukd3UPnrZdFSi68SBwKq9vW1+9xb8bPxLc/evm0e19jX86OeTsf1EWVL1RtqV0eMzJd
	PNjx9bunX8PJuozZlC+7VqyOST0tHEkfXhEYEOQd+mF3R0C80otWF+vOWD5xrz+WjKkLfGnl
	Mfkmf6xQyv8BCoKrv3ADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsVy+t9jAd1VUkEhBnf/CVos+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFjV9trBbbpv9ks5jzIc5i0+NrrBYL25awWFzeNYfN4sj/fkaLTw/+M1ssvX6RyeLU
	9c9sFhOmr2WxeHtnOotF694j7BZPzsxktPhw/yKzxfG14RaTFghZzF23hM3i1sSbQPVvXjBb
	tPx+zGQx/8EOZgdlj9a9E9g81sxbw+gxu+Eii8flvl4mj5XLv7B5bF6h5bFpVSebx51re4C8
	JfUeV040sXrceLWQyePvrP0sHn1bVjF6bL82j9nj8ya5AP6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHGAAKimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzui6kFHRqVHxYo9nAeE2+i5GTQ0LARGLR/y5mCFtM4sK99Wxd
	jFwcQgKLGCVO9f9hgXBeM0pc2fuQBaSKV0BL4mTLX3YQm0VAVWLmvl2sIDabgI7E9m/HmUBs
	UYEwiUNt85gg6gUlfky+BzZIROATk8SsCWdYQRxmgTfMEo9ufQSbKiwQLNHxexaYLSTQzCgx
	cV0+iM0p4C5x/89ERhCbGWjD/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECE6kz6R3MK5qsDjEKMDBqMTDq3EiMESINbGsuDL3EKMEB7OS
	CO9qsaAQId6UxMqq1KL8+KLSnNTiQ4ymwDCYyCwlmpwPTPJ5JfGGxiZmRpZG5oYWRsbmSuK8
	B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoY52qHtB7h2BZ+O6Aw+4DkmZtTAvjLz19mnGvop6T4
	P2Pqw/n+7kduf1yQcnCHDb9/26X1iSUrn6f2b7zhtr9/6TfRBSu4n//0iXQPrd0g3favfWbb
	ImOzi8srs3Wf9X2NXb+tc1rx9sOuq3e0O9cL7GBVFWHcnbVq182trj/PHghPaZhnUDbLWYml
	OCPRUIu5qDgRAHts1SW6AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

This patch is conflicted..Could you rebase on latest Ulf's tree?

Best Regards,
Jaehoon Chung

On 10/30/2014 07:50 PM, Addy Ke wrote:
> The bit of sdio interrupt is 16 in designware implementation,
> but it is 24 in RK3288. This patch add sdio_id0 for the number
> of slot0 in the SDIO interrupt registers, which can be set in
> platform DT table, such as:
> - rockchip,sdio-interrupt-slot0 = <8>;
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/host/dw_mmc-rockchip.c | 13 +++++++++++++
>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>  drivers/mmc/host/dw_mmc.h          |  2 ++
>  include/linux/mmc/dw_mmc.h         |  3 +++
>  4 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
> index f0c2cb1..54655e7 100644
> --- a/drivers/mmc/host/dw_mmc-rockchip.c
> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
> @@ -65,6 +65,18 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
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
> @@ -73,6 +85,7 @@ static const struct dw_mci_drv_data rk3288_drv_data = {
>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>  	.set_ios		= dw_mci_rk3288_set_ios,
>  	.setup_clock    = dw_mci_rk3288_setup_clock,
> +	.parse_dt	= dw_mci_rk3288_parse_dt,
>  };
>  
>  static const struct of_device_id dw_mci_rockchip_match[] = {
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..2ea7467 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -819,7 +819,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  
>  		/* enable clock; only low power if no SDIO */
>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
> +		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>  		mci_writel(host, CLKENA, clk_en_a);
>  
> @@ -1180,10 +1180,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
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
> @@ -2035,8 +2035,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
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
> @@ -2206,6 +2207,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  
>  	slot = mmc_priv(mmc);
>  	slot->id = id;
> +	slot->sdio_id = host->sdio_id0 + id;
>  	slot->mmc = mmc;
>  	slot->host = host;
>  	host->slot[id] = slot;
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 01b99e8..3e966a9 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>   *	with CONFIG_MMC_CLKGATE.
>   * @flags: Random state bits associated with the slot.
>   * @id: Number of this slot.
> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>   * @last_detect_state: Most recently observed card detect state.
>   */
>  struct dw_mci_slot {
> @@ -234,6 +235,7 @@ struct dw_mci_slot {
>  #define DW_MMC_CARD_PRESENT	0
>  #define DW_MMC_CARD_NEED_INIT	1
>  	int			id;
> +	int			sdio_id;
>  	int			last_detect_state;
>  };
>  
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 0013669..4c0d3f2 100644
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
> @@ -193,6 +194,8 @@ struct dw_mci {
>  	bool			vqmmc_enabled;
>  	unsigned long		irq_flags; /* IRQ flags */
>  	int			irq;
> +
> +	int			sdio_id0;
>  };
>  
>  /* DMA ops for Internal/External DMAC interface */
> 

