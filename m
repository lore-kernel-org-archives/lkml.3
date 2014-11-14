Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454AbaKNNSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:18:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63036 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865AbaKNNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:18:29 -0500
X-AuditID: cbfee691-f79b86d000004a5a-97-546601226041
Message-id: <54660120.50305@samsung.com>
Date: Fri, 14 Nov 2014 22:18:24 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Addy Ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org, amstan@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add quirk for data over interrupt timeout
References: <1415970338-2637-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1415970338-2637-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUzMcRzHfe/7+/26jpuvI74yT5c2a6JHPuZh2Nhv5Y9MHmZLTv1cTaX9
	rjxsNjdc8zBcTKdTV5FS64ErrpGnEx0JiZykKJLKyEPlMfcwW/+93vt+vq/v+7t9pFjRynpL
	45NSBDFJlaDkZEzJuBDRX4m2RAaUvVRAwdCABLRdx1nQHejmoCvTxoK+0YIgp+YhC/UFtzio
	fXIWw7HePBaG2ntYuNPzjIHBC/cxVOYOYHjYXYTgsuEHB1mfN4K5o4mFvLR8BhqvZHFQM3QM
	wZfXQxjOPW+QwP3nXznQG0oZ+NhiYEB3rcYD3j7IRPC5rQFDbek6OJ6rgOyyfA6a01845nu7
	MOz/1SGBnNdVeIkPr7um5/gSUwniT2sbGL7x6BEJX1T4jeMrzvvx5uKDHN/SVO1I+Xv4p7a9
	LG/vzpPwf4w3GP5oZTHiLU0mzH81T4kYvUG2MFZIiN8uiHMWb5LF9WUZuWSt/873peVIi674
	HEKeUkpC6Kf+Qg83j6ePW8u5Q0gmVZBziBqqf3H/h6pr6xj3gQHRgQsm5A49iL5Ky3YEqVRO
	ZtLOQV/nBYb40tumCtbJHJlFLf21Eid7kbXUmmZysZyMoYMnWl3SceSThGYW2lwBk15M25v7
	GOfUWBJO33yvcpkUZDn9YGtETvYkK+jBUz9dJux44YYug3PzVFpR8hE7RZS0e1JDdhvjrkRo
	/wkr42xKyWRqvondX5tIb523M3o03jislHGY1jhMm4twMfISkmOSNZvVYuhsjSpRk5qknh2z
	LdGMHGtX97czvQq13VxgRUSKlKPkI1YIkQpWtV2zK9GKQh0t0rG3V8w2x6YmpUQHBs8NgtCQ
	0OCgefPnKifIZ036sVpB1KoUYasgJAtitJiaIGisSCL19NaivKD4fVdjI5He7/qb4I12n5md
	U5Sbz/ifvHq6PS6i2Z7Ka1/Vp0UFaNcfyegyli3NlutyM37vV98dmXhxWbiywD6waDcnhh1u
	0YaJCY/eyV7YVi2/pwtaM80SVdRXGRjwc3rsjj910epe36k538I6wuUzNgREdYZcirGcXAl9
	O+orlYwmThXoh0WN6h9TntYlcQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsVy+t9jQV0lxrQQgzfbWS2W/f/OZNHwYhKr
	RWvHKzaLFzNPsFpMuLyd0WL+kXOsFmeXHWSzOH5pMbNF/5uFrBb/H71mtTj6+iqLxY8Np5gt
	tiz4zmxx7tVKRott03+yWcz5EGex6fE1VouFbUtYLC7vmsNmceR/P6PFpwf/mS2WXr/IZHHq
	+mc2iwnT17JYvL0zncWide8RdosnZ2YyWny4f5HZ4vjacItJC4Qs5q5bwmZxa+JNoPo3L5gt
	Wn4/ZrKY/2AHs4OyR+veCWwea+atYfSY3XCRxeNyXy+Tx8rlX9g8Nq/Q8ti0qpPN4861PUDe
	knqPKyeaWD1uvFrI5PF31n4Wj74tqxg9tl+bx+zxeZNcAH9UA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDjAAlRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZH+fMYito0K14vnY9YwPjLuUuRk4OCQETiT3HT7NA2GISF+6t
	Z+ti5OIQEpjOKPF9wzxGCOc1o8TdtrlADgcHr4CGxLMfqiANLAKqEofnbWYFsdkEdCS2fzvO
	BGKLCoRJHGqbB2bzCghK/Jh8jwVkjojAeyaJmctPgDnMAm+YJR7d+gi2WljAW+Lh1x1gk4QE
	XCVenrjMCGJzCrhJdM74BTaJGWjD/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECE6lz6R3MK5qsDjEKMDBqMTDy+iWGiLEmlhWXJl7iFGC
	g1lJhPf7c6AQb0piZVVqUX58UWlOavEhRlNgGExklhJNzgem+bySeENjEzMjSyNzQwsjY3Ml
	cd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYybWqOMAiY/uBPIWcOusP6r3om1L86UfJCX2zS7
	S/7N94x8vpf/pl5yund/r9aN7atfpGWtPnG54NipP/KPV1RNfNn4YaJ9YvKarVGrU8Wq9WSZ
	Tz35kxNeNtF2+m/ty0z37giEa7xL+vdP5//WNXZSv6NzXu6dWDnZ0tnWxdh0f/TMyLMhmooN
	SizFGYmGWsxFxYkAwiDUgbsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

Did you use the DW_MCI_QUIRK_IDMAC_DTO?
I'm not sure, but i wonder if you get what result when you use above quirk.

And i will check more this patch at next week.

Thanks for your efforts.

Best Regards,
Jaehoon Chung

On 11/14/2014 10:05 PM, Addy Ke wrote:
> From: Addy <addy.ke@rock-chips.com>
> 
> This patch add a new quirk to notify the driver to teminate
> current transfer and report a data timeout to the core,
> if data over interrupt does NOT come within the given time.
> 
> dw_mmc call mmc_request_done func to finish transfer depends on
> data over interrupt. If data over interrupt does not come in
> sending data state, the current transfer will be blocked.
> 
> But this case really exists, when driver reads tuning data from
> card on rk3288-pink2 board. I measured waveforms by oscilloscope
> and found that card clock was always on and data lines were always
> holded high level in sending data state. This is the cause that
> card does NOT send data to host.
> 
> According to synopsys designware databook, the timeout counter is
> started only after the card clock is stopped.
> 
> So if card clock is always on, data read timeout interrupt will NOT come,
> and if data lines are always holded high level, all data-related
> interrupt such as start-bit error, data crc error, data over interrupt,
> end-bit error, and so on, will NOT come too.
> 
> So driver can't get the current state, it can do nothing but wait for.
> 
> This patch is based on https://patchwork.kernel.org/patch/5227941/
> 
> Signed-off-by: Addy <addy.ke@rock-chips.com>
> ---
>  drivers/mmc/host/dw_mmc.c  | 47 +++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/mmc/dw_mmc.h |  5 +++++
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index b4c3044..3960fc3 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1448,6 +1448,17 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
>  	return data->error;
>  }
>  
> +static inline void dw_mci_dto_start_monitor(struct dw_mci *host)
> +{
> +	unsigned int data_tmout_clks;
> +	unsigned int data_tmout_ms;
> +
> +	data_tmout_clks = (mci_readl(host, TMOUT) >> 8);
> +	data_tmout_ms = (data_tmout_clks * 1000 / host->bus_hz) + 250;
> +
> +	mod_timer(&host->dto_timer, jiffies + msecs_to_jiffies(data_tmout_ms));
> +}
> +
>  static void dw_mci_tasklet_func(unsigned long priv)
>  {
>  	struct dw_mci *host = (struct dw_mci *)priv;
> @@ -1522,8 +1533,11 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  			}
>  
>  			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
> -						&host->pending_events))
> +						&host->pending_events)) {
> +				if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
> +					dw_mci_dto_start_monitor(host);
>  				break;
> +			}
>  
>  			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
>  
> @@ -2115,6 +2129,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  		}
>  
>  		if (pending & SDMMC_INT_DATA_OVER) {
> +			if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
> +				del_timer(&host->dto_timer);
> +
>  			mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
>  			if (!host->data_status)
>  				host->data_status = pending;
> @@ -2502,6 +2519,28 @@ ciu_out:
>  	return ret;
>  }
>  
> +static void dw_mci_dto_timer(unsigned long arg)
> +{
> +	struct dw_mci *host = (struct dw_mci *)arg;
> +
> +	switch (host->state) {
> +	case STATE_SENDING_DATA:
> +	case STATE_DATA_BUSY:
> +		/*
> +		* If data over interrupt does NOT come in sending data state,
> +		* we should notify the driver to teminate current transfer
> +		* and report a data timeout to the core.
> +		*/
> +		host->data_status = SDMMC_INT_DRTO;
> +		set_bit(EVENT_DATA_ERROR, &host->pending_events);
> +		set_bit(EVENT_DATA_COMPLETE, &host->pending_events);
> +		tasklet_schedule(&host->tasklet);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  #ifdef CONFIG_OF
>  static struct dw_mci_of_quirks {
>  	char *quirk;
> @@ -2513,6 +2552,9 @@ static struct dw_mci_of_quirks {
>  	}, {
>  		.quirk	= "disable-wp",
>  		.id	= DW_MCI_QUIRK_NO_WRITE_PROTECT,
> +	}, {
> +		.quirk	= "dto-timer",
> +		.id	= DW_MCI_QUIRK_DTO_TIMER,
>  	},
>  };
>  
> @@ -2654,6 +2696,9 @@ int dw_mci_probe(struct dw_mci *host)
>  
>  	spin_lock_init(&host->lock);
>  	INIT_LIST_HEAD(&host->queue);
> +	if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
> +		setup_timer(&host->dto_timer,
> +			    dw_mci_dto_timer, (unsigned long)host);
>  
>  	/*
>  	 * Get the host data width - this assumes that HCON has been set with
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 42b724e..2477813 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -98,6 +98,7 @@ struct mmc_data;
>   * @irq_flags: The flags to be passed to request_irq.
>   * @irq: The irq value to be passed to request_irq.
>   * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
> + * @dto_timer: Timer for data over interrupt timeout.
>   *
>   * Locking
>   * =======
> @@ -196,6 +197,8 @@ struct dw_mci {
>  	int			irq;
>  
>  	int			sdio_id0;
> +
> +	struct timer_list	dto_timer;
>  };
>  
>  /* DMA ops for Internal/External DMAC interface */
> @@ -220,6 +223,8 @@ struct dw_mci_dma_ops {
>  #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
>  /* No write protect */
>  #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
> +/* Timer for data over interrupt timeout */
> +#define DW_MCI_QUIRK_DTO_TIMER			BIT(5)
>  
>  /* Slot level quirks */
>  /* This slot has no write protect */
> 

