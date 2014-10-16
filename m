Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaJPITg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:19:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51529 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaJPITc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:19:32 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-9a-543f7f91fc93
Message-id: <543F7F91.1010609@samsung.com>
Date: Thu, 16 Oct 2014 17:19:29 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: dw_mmc: Remove old card detect infrastructure
References: <1413304389-6580-1-git-send-email-dianders@chromium.org>
In-reply-to: <1413304389-6580-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkRHdivX2IQeNFSYuV7/8yWiz7/53J
	4sG8bWwWEy5vZ7Q4u+wgm8XlXXPYLI7872e0eHJmJqPFh/sXmS2Orw134PKY3XCRxePOtT1s
	HjdeLWTy+DtrP4tH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZVyf+o+5YKdHxaWzzg2Msyy6
	GDk5JARMJM52/GKDsMUkLtxbD2RzcQgJLGWU2HRiPTNMUeO3i6wQiUWMEhOuz2KHcF4zShxt
	Wg7kcHDwCmhJ9PfWgTSwCKhKtJ58wApiswnoSGz/dpwJxBYVCJM41DYPzOYVEJT4MfkeC4gt
	IlAu0bj1BNhmZoFXjBJ3Zl4BSwgLuEtsvXucEcQWEnCROLj+OVgzp4CrxO1/G8AWMAMt2N86
	jQ3ClpfYvOYtM8ggCYGX7BJLrp1lhbhIQOLb5EMsIIdKCMhKbDoA9ZmkxMEVN1gmMIrNQnLT
	LCRjZyEZu4CReRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYHSe/vdswg7GewesDzEKcDAq
	8fBeCLAPEWJNLCuuzD3EaAp0xURmKdHkfGAKyCuJNzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PCmxsDLkzd8vuAdv2XOusLeUkZFjbZb0uvPei5sER4
	jWb0zeU33ZY9YTQw0RA+P4ff5Dnvm/8qNxp/nPA8buW9rVToTN92dTZTe67gne+Oly2Y+9hw
	Q+LxKy75tS2V7k1syQr9q5z4dy3h5u6c+3CN7ia/TeqhR9n9Oh7btgityLy6TZPv30slluKM
	REMt5qLiRABsRhFvyQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xgO7EevsQg0+/+S1Wvv/LaLHs/3cm
	iwfztrFZTLi8ndHi7LKDbBaXd81hszjyv5/R4smZmYwWH+5fZLY4vjbcgctjdsNFFo871/aw
	edx4tZDJ4++s/SwefVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjHj+tR/zAU7PSounXVuYJxl0cXIySEhYCLR+O0iK4QtJnHh3nq2LkYuDiGBRYwSE67P
	YodwXjNKHG1aDuRwcPAKaEn099aBNLAIqEq0nnwA1swmoCOx/dtxJhBbVCBM4lDbPDCbV0BQ
	4sfkeywgtohAuUTj1hNgC5gFXjFK3Jl5BSwhLOAusfXucUYQW0jAReLg+udgzZwCrhK3/20A
	W8AMtGB/6zQ2CFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEx/4z6R2MqxosDjEKcDAq8fBqBNuHCLEmlhVX5h5ilOBgVhLhbS4ECvGmJFZWpRbl
	xxeV5qQWH2I0BQbBRGYp0eR8YFrKK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQ
	WgTTx8TBKdXA2PHbWOKy7c+g0r2TuwrWT7NRfPHp80zWe91ay06dfvZrW197ZRhLXMuXmvO6
	DnH/tK3DS+uL/fPmXhRcfPAgR/iNPe7Ou9y29DOzR5b+uR1orVh9fjUr58H4i27OVn7Vbm0s
	fZnMvOxW/asPCfpYfdsq93sme4DQFCfVW3ya2e6mZj5Tl5sosRRnJBpqMRcVJwIAEQHmBBMD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Doug.

Looks good to me.

Tested-by: Jaehoon Chung <jh80.chung@samsung.com>
with exynos3/4 series.

Need to check exynos5 with using other "card detect" mechanism.

Best Regards,
Jaehoon Chung

On 10/15/2014 01:33 AM, Doug Anderson wrote:
> The dw_mmc driver had a bunch of code that ran whenever a card was
> ejected and inserted.  However, this code was old and crufty and
> should be removed.  Some evidence that it's really not needed:
> 
> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>    using the built-in card detect mechanism.  The 'cd-gpio' code
>    doesn't run any of the crufty old code but yet still works.
> 
> 2. While looking at this, I realized that my old change (369ac86 mmc:
>    dw_mmc: don't queue up a card detect at slot startup) actually
>    castrated the old code a little bit already and nobody noticed.
>    Specifically "last_detect_state" was left as 0 at bootup.  That
>    means that on the first card removal none of the crufty code ran.
> 
> 3. I can run "while true; do dd if=/dev/mmcblk1 of=/dev/null; done"
>    while ejecting and inserting an SD Card and the world doesn't
>    explode.
> 
> If some of the crufty old code is actually needed, we should justify
> it and also put it in some place where it will be run even with
> "cd-gpio".
> 
> Note that in my case I'm using the "cd-gpio" mechanism but for various
> reasons the hardware triggers a dw_mmc "card detect" at bootup.  That
> was actually causing a real bug.  The card detect workqueue was
> running while the system was trying to enumerate the card.  The
> "present != slot->last_detect_state" triggered and we were doing all
> kinds of crazy stuff and messing up enumeration.  The new mechanism of
> just asking the core to check the card is much safer and then the
> bogus interrupt doesn't hurt.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c  | 121 ++++++++-------------------------------------
>  drivers/mmc/host/dw_mmc.h  |   2 -
>  include/linux/mmc/dw_mmc.h |   2 -
>  3 files changed, 20 insertions(+), 105 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 69f0cc6..6a86495 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -34,7 +34,6 @@
>  #include <linux/mmc/dw_mmc.h>
>  #include <linux/bitops.h>
>  #include <linux/regulator/consumer.h>
> -#include <linux/workqueue.h>
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/mmc/slot-gpio.h>
> @@ -1954,6 +1953,23 @@ static void dw_mci_cmd_interrupt(struct dw_mci *host, u32 status)
>  	tasklet_schedule(&host->tasklet);
>  }
>  
> +static void dw_mci_handle_cd(struct dw_mci *host)
> +{
> +	int i;
> +
> +	for (i = 0; i < host->num_slots; i++) {
> +		struct dw_mci_slot *slot = host->slot[i];
> +
> +		if (!slot)
> +			continue;
> +
> +		if (slot->mmc->ops->card_event)
> +			slot->mmc->ops->card_event(slot->mmc);
> +		mmc_detect_change(slot->mmc,
> +			msecs_to_jiffies(host->pdata->detect_delay_ms));
> +	}
> +}
> +
>  static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  {
>  	struct dw_mci *host = dev_id;
> @@ -2029,7 +2045,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  
>  		if (pending & SDMMC_INT_CD) {
>  			mci_writel(host, RINTSTS, SDMMC_INT_CD);
> -			queue_work(host->card_workqueue, &host->card_work);
> +			dw_mci_handle_cd(host);
>  		}
>  
>  		/* Handle SDIO Interrupts */
> @@ -2056,88 +2072,6 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static void dw_mci_work_routine_card(struct work_struct *work)
> -{
> -	struct dw_mci *host = container_of(work, struct dw_mci, card_work);
> -	int i;
> -
> -	for (i = 0; i < host->num_slots; i++) {
> -		struct dw_mci_slot *slot = host->slot[i];
> -		struct mmc_host *mmc = slot->mmc;
> -		struct mmc_request *mrq;
> -		int present;
> -
> -		present = dw_mci_get_cd(mmc);
> -		while (present != slot->last_detect_state) {
> -			dev_dbg(&slot->mmc->class_dev, "card %s\n",
> -				present ? "inserted" : "removed");
> -
> -			spin_lock_bh(&host->lock);
> -
> -			/* Card change detected */
> -			slot->last_detect_state = present;
> -
> -			/* Clean up queue if present */
> -			mrq = slot->mrq;
> -			if (mrq) {
> -				if (mrq == host->mrq) {
> -					host->data = NULL;
> -					host->cmd = NULL;
> -
> -					switch (host->state) {
> -					case STATE_IDLE:
> -					case STATE_WAITING_CMD11_DONE:
> -						break;
> -					case STATE_SENDING_CMD11:
> -					case STATE_SENDING_CMD:
> -						mrq->cmd->error = -ENOMEDIUM;
> -						if (!mrq->data)
> -							break;
> -						/* fall through */
> -					case STATE_SENDING_DATA:
> -						mrq->data->error = -ENOMEDIUM;
> -						dw_mci_stop_dma(host);
> -						break;
> -					case STATE_DATA_BUSY:
> -					case STATE_DATA_ERROR:
> -						if (mrq->data->error == -EINPROGRESS)
> -							mrq->data->error = -ENOMEDIUM;
> -						/* fall through */
> -					case STATE_SENDING_STOP:
> -						if (mrq->stop)
> -							mrq->stop->error = -ENOMEDIUM;
> -						break;
> -					}
> -
> -					dw_mci_request_end(host, mrq);
> -				} else {
> -					list_del(&slot->queue_node);
> -					mrq->cmd->error = -ENOMEDIUM;
> -					if (mrq->data)
> -						mrq->data->error = -ENOMEDIUM;
> -					if (mrq->stop)
> -						mrq->stop->error = -ENOMEDIUM;
> -
> -					spin_unlock(&host->lock);
> -					mmc_request_done(slot->mmc, mrq);
> -					spin_lock(&host->lock);
> -				}
> -			}
> -
> -			/* Power down slot */
> -			if (present == 0)
> -				dw_mci_reset(host);
> -
> -			spin_unlock_bh(&host->lock);
> -
> -			present = dw_mci_get_cd(mmc);
> -		}
> -
> -		mmc_detect_change(slot->mmc,
> -			msecs_to_jiffies(host->pdata->detect_delay_ms));
> -	}
> -}
> -
>  #ifdef CONFIG_OF
>  /* given a slot id, find out the device node representing that slot */
>  static struct device_node *dw_mci_of_find_slot_node(struct device *dev, u8 slot)
> @@ -2289,9 +2223,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	dw_mci_init_debugfs(slot);
>  #endif
>  
> -	/* Card initially undetected */
> -	slot->last_detect_state = 0;
> -
>  	return 0;
>  
>  err_host_allocated:
> @@ -2672,17 +2603,10 @@ int dw_mci_probe(struct dw_mci *host)
>  		host->data_offset = DATA_240A_OFFSET;
>  
>  	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
> -	host->card_workqueue = alloc_workqueue("dw-mci-card",
> -			WQ_MEM_RECLAIM, 1);
> -	if (!host->card_workqueue) {
> -		ret = -ENOMEM;
> -		goto err_dmaunmap;
> -	}
> -	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>  	ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
>  			       host->irq_flags, "dw-mci", host);
>  	if (ret)
> -		goto err_workqueue;
> +		goto err_dmaunmap;
>  
>  	if (host->pdata->num_slots)
>  		host->num_slots = host->pdata->num_slots;
> @@ -2718,7 +2642,7 @@ int dw_mci_probe(struct dw_mci *host)
>  	} else {
>  		dev_dbg(host->dev, "attempted to initialize %d slots, "
>  					"but failed on all\n", host->num_slots);
> -		goto err_workqueue;
> +		goto err_dmaunmap;
>  	}
>  
>  	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
> @@ -2726,9 +2650,6 @@ int dw_mci_probe(struct dw_mci *host)
>  
>  	return 0;
>  
> -err_workqueue:
> -	destroy_workqueue(host->card_workqueue);
> -
>  err_dmaunmap:
>  	if (host->use_dma && host->dma_ops->exit)
>  		host->dma_ops->exit(host);
> @@ -2762,8 +2683,6 @@ void dw_mci_remove(struct dw_mci *host)
>  	mci_writel(host, CLKENA, 0);
>  	mci_writel(host, CLKSRC, 0);
>  
> -	destroy_workqueue(host->card_workqueue);
> -
>  	if (host->use_dma && host->dma_ops->exit)
>  		host->dma_ops->exit(host);
>  
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 01b99e8..71d4995 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -214,7 +214,6 @@ extern int dw_mci_resume(struct dw_mci *host);
>   *	with CONFIG_MMC_CLKGATE.
>   * @flags: Random state bits associated with the slot.
>   * @id: Number of this slot.
> - * @last_detect_state: Most recently observed card detect state.
>   */
>  struct dw_mci_slot {
>  	struct mmc_host		*mmc;
> @@ -234,7 +233,6 @@ struct dw_mci_slot {
>  #define DW_MMC_CARD_PRESENT	0
>  #define DW_MMC_CARD_NEED_INIT	1
>  	int			id;
> -	int			last_detect_state;
>  };
>  
>  struct dw_mci_tuning_data {
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 0013669..69d0814 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -135,7 +135,6 @@ struct dw_mci {
>  	struct mmc_command	stop_abort;
>  	unsigned int		prev_blksz;
>  	unsigned char		timing;
> -	struct workqueue_struct	*card_workqueue;
>  
>  	/* DMA interface members*/
>  	int			use_dma;
> @@ -154,7 +153,6 @@ struct dw_mci {
>  	u32			stop_cmdr;
>  	u32			dir_status;
>  	struct tasklet_struct	tasklet;
> -	struct work_struct	card_work;
>  	unsigned long		pending_events;
>  	unsigned long		completed_events;
>  	enum dw_mci_state	state;
> 

