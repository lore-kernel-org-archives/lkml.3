Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbbAHB6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:58:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41340 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbAHB6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:58:11 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f0-54ade42f8194
Message-id: <54ADE42F.9070200@samsung.com>
Date: Thu, 08 Jan 2015 10:58:07 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
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
Subject: Re: [PATCH v5] mmc: dw_mmc: add quirk for broken data transfer over
 scheme
References: <1419585223-8214-1-git-send-email-addy.ke@rock-chips.com>
 <1420446088-15710-1-git-send-email-addy.ke@rock-chips.com>
In-reply-to: <1420446088-15710-1-git-send-email-addy.ke@rock-chips.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa1CMURjHnfe879tu047XqhwZGrl8aEitjcdl0gfDixmDXGaYkZV3Krrs
	7C6DGWMtuTTUljFpJS0p1i5mSzWIaqLcqi3daLYbJpUR0YUhe2H05czzP//f8z/PmXlEWGpn
	/ESxCRpBlaCIC2A9abO3XDM/+J1lc3DpMAV5Y45D25POQNLpXhZ6MqsZ0DcUI7hSWcPAq7xy
	Fqrqr2FI7TcyMNbVx8CTvkYaRu4+x1CYM4yhpvcmgqKMURayBnaCtbuJAePJXBoa7mexUDmW
	iuBrxxiG6802Cp43D7Kgz7DQ8Kktg4ak0koPePcyE8FAuw1DlWUbpOdI4fLtXBbepLU6+P4e
	DCd+dlNwpaMEh8/ik0r1LG/ONiP+ktZG8w0p5yj+Zv43li+4EchbTWdYvq3poUPlHuVfV+sY
	vqXXSPG/DI9pPqXQhPjipmzMD1pnbJi43XP5HiEu9oCgWhC2yzOmIN1IKX+EH2y7d4HSokey
	ZCQWEU5Oak2N2F37kjr7HTYZeYqk3HVEOl8YqH9QZ2kLchsZiAz8eODhFn2InH2azjopCRdI
	8htzkLOmuTnk+NsaVzfLzSPFQ1Wu2ofbStJauxk3P4mMnLfTziBv7jNFMvOrXQJz/Zh0vflC
	O6nJ3BbSOjSE3c/pEDmVXeYyxNxqojXZHIbI0RFE2m2BzmvM+ZMC8ycXT7guMRnMy6TcI3Fk
	6HwF7eQJN51Yy/5+eiopv9FC65GvYdxQhv+phnGpOQibkI+gjFKqd0er5EFqRbx6f0J0UFRi
	vBU51u7F7w/6EmQvW1aBOBEK8JIMtFs2SxnFAfWh+AoU6hgiDfv5RCU6NjVBExmycJEMQuWh
	C2WLlywKmCLp8xuNkHLRCo2wTxCUgipStT9OUFcgSiT206IzU9bkrSQl5iJTZ53HTKmsSgy3
	WOWRx/UR3xs7iP/HuWHBZ3vund41/Kwm5mThFy/jVV3R7OF1x0afxF7VdW+aHmaf/ezte0vI
	EWv15dqRyo3Nv+62UA8jI9YvTdtbG1s34rPivcweJdkhmSD3mKZZ1VzunXjs8IOLRLdN62W9
	vfZjAK2OUYQEYpVa8QcOQeifcQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsVy+t9jQV39J2tDDOZtMLJY9v87k0XDi0ms
	Fq0dr9gsXsw8wWox4fJ2Rov5R86xWpxddpDN4vilxcwW/W8Wslr8f/Sa1eLo66ssFj82nGK2
	2LLgO7PFuVcrGS22Tf/JZjHnQ5zFpsfXWC0Wti1hsbi8aw6bxZH//YwWnx78Z7ZYev0ik8Wp
	65/ZLCZMX8ti8fbOdBaL1r1H2C2enJnJaPHh/kVmi+Nrwy0mLRCymLtuCZvFrYk3gerfvGC2
	aPn9mMli/oMdzA7KHq17J7B5rJm3htFjdsNFFo/Lfb1MHiuXf2Hz2LxCy2PTqk42jzvX9gB5
	S+o9rpxoYvW48Wohk8ffWftZPPq2rGL02H5tHrPH501yAfxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOcAAVFIoS8wpBQoFJBYXK+nbYZoQGuKm
	awHTGKHrGxIE12NkgAYS1jBmbJ60kKngl0PFna1TmRoY9xl1MXJySAiYSDzce4MRwhaTuHBv
	PVsXIxeHkMB0RokPv3azQzivGSV6jk1iA6niFdCSWH51AVgHi4CqRPPtc0wgNpuAjsT2b8fB
	bFGBMImJNx+zQtQLSvyYfI8FZJCIwHsmiZnLT4A5zAJvmCUe3frIAlIlLBAqcfPbN2aIdU2M
	Eu3zDoAlOAXcJRpWXQRKcAB16Encv6gFEmYWkJfYvOYt8wRGgVlIlsxCqJqFpGoBI/MqRtHU
	guSC4qT0XEO94sTc4tK8dL3k/NxNjOBU+kxqB+PKBotDjAIcjEo8vB/urw0RYk0sK67MPcQo
	wcGsJMLbdRYoxJuSWFmVWpQfX1Sak1p8iNEUGAQTmaVEk/OBaT6vJN7Q2MTMyNLI3NDCyNhc
	SZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoGx8bKHgvThlhnvgo8/udzmaXymccEReZ3amVMP
	r2DnSdpbfWaf1sGzBcZLtHhErfTUr561v8en9eNl5N6i+O4Hfl0rfj5W6y2SOczK9jJydnRd
	1oxLFR47bn1bVyNxmufXm6T8nNUr5I5tqBP/uUDi2i+B3xdy7ye43U27JFHLvzleZr1a0I0p
	SizFGYmGWsxFxYkACl6C77sDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

On 01/05/2015 05:21 PM, Addy Ke wrote:
> This patch add a new quirk to add a s/w timer to notify the driver
> to terminate current transfer and report a data timeout to the core,
> if DTO interrupt does NOT come within the given time.
> 
> dw_mmc call mmc_request_done func to finish transfer depends on
> DTO interrupt. If DTO interrupt does not come in sending data state,
> the current transfer will be blocked.
> 
> We got the reply from synopsys:
> There are two counters but both use the same value of [31:8] bits.
> Data timeout counter doesn't wait for stop clock and you should get
> DRTO even when the clock is not stopped.
> Host Starvation timeout counter is triggered with stop clock condition.
> 
> This means that host should get DRTO and DTO interrupt.
> 
> But this case really exists, when driver reads tuning data from
> card on RK3288-pink2 board. I measured waveforms by oscilloscope
> and found that card clock was always on and data lines were always
> holded high level in sending data state.
> 
> There are two possibility that data over interrupt doesn't come in
> reading data state on RK3X SoCs:
> - get command done interrupt, but doesn't get any data-related interrupt.
> - get data error interrupt, but doesn't get data over interrupt.
> 
> We don't know why we have this problem, but we need it to fix this problem now.
> And I will post a follow up change when we find the root cause.
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
> ---
> Changes in v2:
> - fix some typo.
> - remove extra timeout value (250ms).
> - remove dw_mci_dto_start_monitor func.
> - use "broken-dto" for new quirk and change Subject for it.
> 
> Changes in v3:
> - Remove dts for broken-dto, just add this quirk in dw_mci_rockchip_init
> 
> Changes in v4:
> - fix bug that may cause 32 bit overflow by (drto_clks * 1000).
> - doesn't call mod_timer in writing data state, becase TMOUT register only
>   for reading data.
> 
> Changes in v5:
> - fix some typo.
> - add a buffer for drto_ms.
> - move drto_ms related code to a helper function.
> 
>  drivers/mmc/host/dw_mmc-rockchip.c |  3 ++
>  drivers/mmc/host/dw_mmc.c          | 71 ++++++++++++++++++++++++++++++++++++--
>  include/linux/mmc/dw_mmc.h         |  5 +++
>  3 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
> index 5650ac4..ba92ebd 100644
> --- a/drivers/mmc/host/dw_mmc-rockchip.c
> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
> @@ -73,6 +73,9 @@ static int dw_mci_rockchip_init(struct dw_mci *host)
>  	/* It is slot 8 on Rockchip SoCs */
>  	host->sdio_id0 = 8;
>  
> +	/* It needs this quirk on all Rockchip SoCs */
> +	host->pdata->quirks |= DW_MCI_QUIRK_BROKEN_DTO;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 6e4d864..ace4b40 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1468,6 +1468,20 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
>  	return data->error;
>  }
>  
> +static unsigned int dw_mci_get_drto_ms(struct dw_mci *host)
> +{
> +	unsigned int drto_clks;
> +	unsigned int drto_ms;
> +
> +	drto_clks = mci_readl(host, TMOUT) >> 8;
> +	drto_ms = DIV_ROUND_UP(drto_clks, host->bus_hz / 1000);
> +
> +	/* add a buffer */
> +	drto_ms += 10;

Add a buffer? What means?

> +
> +	return drto_ms;
> +}

dw_mci_set_drto() instead of dw_mci_get_drto_ms().

Then you can include the codes relevant to broken-dto.

static unsigned int (or void) dw_mci_set_drto(struct dw_mci *host) {

	if (!(host->quirks & DW_MCI_QUIRK_BROKEN_DTO))
		return;

	... 
	add codes relevant to broken-dtop (mod_timer) at here.
}

If you need to start timer, you have only to call dw_mci_set_drto().
how about?

Best Regards,
Jaehoon Chung

> +
>  static void dw_mci_tasklet_func(unsigned long priv)
>  {
>  	struct dw_mci *host = (struct dw_mci *)priv;
> @@ -1477,6 +1491,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  	enum dw_mci_state state;
>  	enum dw_mci_state prev_state;
>  	unsigned int err;
> +	unsigned int drto_ms;
>  
>  	spin_lock(&host->lock);
>  
> @@ -1542,8 +1557,19 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  			}
>  
>  			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
> -						&host->pending_events))
> +						&host->pending_events)) {
> +				/*
> +				 * If all data-related interrupts don't come
> +				 * within the given time in reading data state.
> +				 */
> +				if ((host->quirks & DW_MCI_QUIRK_BROKEN_DTO) &&
> +				    (host->dir_status == DW_MCI_RECV_STATUS)) {
> +					drto_ms = dw_mci_get_drto_ms(host);
> +					mod_timer(&host->dto_timer, jiffies +
> +						  msecs_to_jiffies(drto_ms));
> +				}
>  				break;
> +			}
>  
>  			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
>  
> @@ -1573,8 +1599,20 @@ static void dw_mci_tasklet_func(unsigned long priv)
>  
>  		case STATE_DATA_BUSY:
>  			if (!test_and_clear_bit(EVENT_DATA_COMPLETE,
> -						&host->pending_events))
> +						&host->pending_events)) {
> +				/*
> +				 * If data error interrupt comes but data over
> +				 * interrupt doesn't come within the given time.
> +				 * in reading data state.
> +				 */
> +				if ((host->quirks & DW_MCI_QUIRK_BROKEN_DTO) &&
> +				    (host->dir_status == DW_MCI_RECV_STATUS)) {
> +					drto_ms = dw_mci_get_drto_ms(host);
> +					mod_timer(&host->dto_timer, jiffies +
> +						  msecs_to_jiffies(drto_ms));
> +				}
>  				break;
> +			}
>  
>  			host->data = NULL;
>  			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
> @@ -2135,6 +2173,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  		}
>  
>  		if (pending & SDMMC_INT_DATA_OVER) {
> +			if (host->quirks & DW_MCI_QUIRK_BROKEN_DTO)
> +				del_timer(&host->dto_timer);
> +
>  			mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
>  			if (!host->data_status)
>  				host->data_status = pending;
> @@ -2522,6 +2563,28 @@ ciu_out:
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
> +		 * If DTO interrupt does NOT come in sending data state,
> +		 * we should notify the driver to terminate current transfer
> +		 * and report a data timeout to the core.
> +		 */
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
> @@ -2670,6 +2733,10 @@ int dw_mci_probe(struct dw_mci *host)
>  
>  	host->quirks = host->pdata->quirks;
>  
> +	if (host->quirks & DW_MCI_QUIRK_BROKEN_DTO)
> +		setup_timer(&host->dto_timer,
> +			    dw_mci_dto_timer, (unsigned long)host);
> +
>  	spin_lock_init(&host->lock);
>  	spin_lock_init(&host->irq_lock);
>  	INIT_LIST_HEAD(&host->queue);
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 471fb31..2ece0dd 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -98,6 +98,7 @@ struct mmc_data;
>   * @irq_flags: The flags to be passed to request_irq.
>   * @irq: The irq value to be passed to request_irq.
>   * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
> + * @dto_timer: Timer for broken data transfer over scheme.
>   *
>   * Locking
>   * =======
> @@ -202,6 +203,8 @@ struct dw_mci {
>  	int			irq;
>  
>  	int			sdio_id0;
> +
> +	struct timer_list       dto_timer;
>  };
>  
>  /* DMA ops for Internal/External DMAC interface */
> @@ -226,6 +229,8 @@ struct dw_mci_dma_ops {
>  #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
>  /* No write protect */
>  #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
> +/* Timer for broken data transfer over scheme */
> +#define DW_MCI_QUIRK_BROKEN_DTO			BIT(5)
>  
>  /* Slot level quirks */
>  /* This slot has no write protect */
> 

