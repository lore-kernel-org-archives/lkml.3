Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaJPJiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:38:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36463 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJPJiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:38:12 -0400
X-AuditID: cbfee68f-f791c6d000004834-72-543f9202b5be
Message-id: <543F9202.8010806@samsung.com>
Date: Thu, 16 Oct 2014 18:38:10 +0900
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
 <543F7F91.1010609@samsung.com>
In-reply-to: <543F7F91.1010609@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkWJdpkn2Iwfr7WhYr3/9ltFj2/zuT
	xYN529gsJlzezmhxdtlBNovLu+awWRz5389o8eTMTEaLD/cvMlscXxvuwOUxu+Eii8eda3vY
	PG68Wsjk8XfWfhaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyuj4uZ+xoN+v4vmtTSwNjFNt
	uxg5OCQETCQmfnbtYuQEMsUkLtxbz9bFyMUhJLCUUeLH83YWiISJxLfWicwQiUWMEqu2HmGB
	cF4zSmw9OZUdpIpXQEviw7OfTCA2i4CqxKVlV1lBbDYBHYnt346DxUUFwiQOtc1jgqgXlPgx
	+R7YBhGBconGrSfAVjMLvGKUuDPzClhCWMBdYuvd44wgtpBAqsT/g7/B4pwC2hKTzi4FW8AM
	tGB/6zQ2CFteYvOat8wQr71kl9jKC3GPgMS3yYdYIMKyEpsOMEM8JilxcMUNlgmMYrOQXDQL
	ydBZSIYuYGRexSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREYm6f/PevfwXj3gPUhRgEORiUe
	Xo1g+xAh1sSy4srcQ4ymQFdMZJYSTc4HJoC8knhDYzMjC1MTU2Mjc0szJXHehVI/g4UE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwnupLU7YpOLld5OWHXxfNguW+L/kSEPSw9I+fpcM30ysM
	G6ddnza1ad/S2wIT9q7fzLveI3fyjjlWbe8XpdU7r9vFm56yZPL5c2em1zUqH1ki51m9LINr
	Xr3NX24Whu06XTGrChzLTzzc9Hb/EUOumZz+2yO9Lu1+y6nx8T6Xw4OFF1+bWG+Z9FKJpTgj
	0VCLuag4EQDIyXV3yAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgC7TJPsQg9/bFSxWvv/LaLHs/3cm
	iwfztrFZTLi8ndHi7LKDbBaXd81hszjyv5/R4smZmYwWH+5fZLY4vjbcgctjdsNFFo871/aw
	edx4tZDJ4++s/SwefVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjGj4+d+xoJ+v4rntzaxNDBOte1i5OSQEDCR+NY6kRnCFpO4cG89WxcjF4eQwCJGiVVb
	j7BAOK8ZJbaenMoOUsUroCXx4dlPJhCbRUBV4tKyq6wgNpuAjsT2b8fB4qICYRKH2uYxQdQL
	SvyYfI8FxBYRKJdo3HoCbAOzwCtGiTszr4AlhAXcJbbePc4IYgsJpEr8P/gbLM4poC0x6exS
	sAXMQAv2t05jg7DlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcPw/k9rBuLLB4hCjAAejEg+vRrB9iBBrYllxZe4hRgkOZiUR3uZCoBBvSmJlVWpR
	fnxRaU5q8SFGU2AQTGSWEk3OB6amvJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakF
	qUUwfUwcnFINjP1Mu4+941H9L2I/J9k2JMhtu8n71/8sY7LXKTXceFS/c6m8foev7dZ+zqJk
	q7mx/3iDPny3EnjQKP/y6sX5/OJ/OUQTFlrnbtnLccwpNG3a9r8/M1svd6n3th+6Xfl+eUP+
	nTnGd+JjZ24PN7ispRaw//frOH5vF9XF3Btlfx1iEzw6K+JouBJLcUaioRZzUXEiAPPrMGAV	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Doug.

Add one comment.

On 10/16/2014 05:19 PM, Jaehoon Chung wrote:
> Hi, Doug.
> 
> Looks good to me.
> 
> Tested-by: Jaehoon Chung <jh80.chung@samsung.com>
> with exynos3/4 series.
> 
> Need to check exynos5 with using other "card detect" mechanism.
> 
> Best Regards,
> Jaehoon Chung
> 
> On 10/15/2014 01:33 AM, Doug Anderson wrote:
>> The dw_mmc driver had a bunch of code that ran whenever a card was
>> ejected and inserted.  However, this code was old and crufty and
>> should be removed.  Some evidence that it's really not needed:
>>
>> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>>    using the built-in card detect mechanism.  The 'cd-gpio' code
>>    doesn't run any of the crufty old code but yet still works.
>>
>> 2. While looking at this, I realized that my old change (369ac86 mmc:
>>    dw_mmc: don't queue up a card detect at slot startup) actually
>>    castrated the old code a little bit already and nobody noticed.
>>    Specifically "last_detect_state" was left as 0 at bootup.  That
>>    means that on the first card removal none of the crufty code ran.
>>
>> 3. I can run "while true; do dd if=/dev/mmcblk1 of=/dev/null; done"
>>    while ejecting and inserting an SD Card and the world doesn't
>>    explode.
>>
>> If some of the crufty old code is actually needed, we should justify
>> it and also put it in some place where it will be run even with
>> "cd-gpio".
>>
>> Note that in my case I'm using the "cd-gpio" mechanism but for various
>> reasons the hardware triggers a dw_mmc "card detect" at bootup.  That
>> was actually causing a real bug.  The card detect workqueue was
>> running while the system was trying to enumerate the card.  The
>> "present != slot->last_detect_state" triggered and we were doing all
>> kinds of crazy stuff and messing up enumeration.  The new mechanism of
>> just asking the core to check the card is much safer and then the
>> bogus interrupt doesn't hurt.

Did you read the Card-detect Recommendation?
There is a Recommendation for Card-detect(CDT) at TRM.
We don't read the CDETECT register(0x50) anywhere. Could you share this register value after detecting?

And I think "last_detect_state" is used for "software should read card detect register and store in memory."

Best Regards,
Jaehoon Chung

>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mmc/host/dw_mmc.c  | 121 ++++++++-------------------------------------
>>  drivers/mmc/host/dw_mmc.h  |   2 -
>>  include/linux/mmc/dw_mmc.h |   2 -
>>  3 files changed, 20 insertions(+), 105 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 69f0cc6..6a86495 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -34,7 +34,6 @@
>>  #include <linux/mmc/dw_mmc.h>
>>  #include <linux/bitops.h>
>>  #include <linux/regulator/consumer.h>
>> -#include <linux/workqueue.h>
>>  #include <linux/of.h>
>>  #include <linux/of_gpio.h>
>>  #include <linux/mmc/slot-gpio.h>
>> @@ -1954,6 +1953,23 @@ static void dw_mci_cmd_interrupt(struct dw_mci *host, u32 status)
>>  	tasklet_schedule(&host->tasklet);
>>  }
>>  
>> +static void dw_mci_handle_cd(struct dw_mci *host)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < host->num_slots; i++) {
>> +		struct dw_mci_slot *slot = host->slot[i];
>> +
>> +		if (!slot)
>> +			continue;
>> +
>> +		if (slot->mmc->ops->card_event)
>> +			slot->mmc->ops->card_event(slot->mmc);
>> +		mmc_detect_change(slot->mmc,
>> +			msecs_to_jiffies(host->pdata->detect_delay_ms));
>> +	}
>> +}
>> +
>>  static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>  {
>>  	struct dw_mci *host = dev_id;
>> @@ -2029,7 +2045,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>  
>>  		if (pending & SDMMC_INT_CD) {
>>  			mci_writel(host, RINTSTS, SDMMC_INT_CD);
>> -			queue_work(host->card_workqueue, &host->card_work);
>> +			dw_mci_handle_cd(host);
>>  		}
>>  
>>  		/* Handle SDIO Interrupts */
>> @@ -2056,88 +2072,6 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>  	return IRQ_HANDLED;
>>  }
>>  
>> -static void dw_mci_work_routine_card(struct work_struct *work)
>> -{
>> -	struct dw_mci *host = container_of(work, struct dw_mci, card_work);
>> -	int i;
>> -
>> -	for (i = 0; i < host->num_slots; i++) {
>> -		struct dw_mci_slot *slot = host->slot[i];
>> -		struct mmc_host *mmc = slot->mmc;
>> -		struct mmc_request *mrq;
>> -		int present;
>> -
>> -		present = dw_mci_get_cd(mmc);
>> -		while (present != slot->last_detect_state) {
>> -			dev_dbg(&slot->mmc->class_dev, "card %s\n",
>> -				present ? "inserted" : "removed");
>> -
>> -			spin_lock_bh(&host->lock);
>> -
>> -			/* Card change detected */
>> -			slot->last_detect_state = present;
>> -
>> -			/* Clean up queue if present */
>> -			mrq = slot->mrq;
>> -			if (mrq) {
>> -				if (mrq == host->mrq) {
>> -					host->data = NULL;
>> -					host->cmd = NULL;
>> -
>> -					switch (host->state) {
>> -					case STATE_IDLE:
>> -					case STATE_WAITING_CMD11_DONE:
>> -						break;
>> -					case STATE_SENDING_CMD11:
>> -					case STATE_SENDING_CMD:
>> -						mrq->cmd->error = -ENOMEDIUM;
>> -						if (!mrq->data)
>> -							break;
>> -						/* fall through */
>> -					case STATE_SENDING_DATA:
>> -						mrq->data->error = -ENOMEDIUM;
>> -						dw_mci_stop_dma(host);
>> -						break;
>> -					case STATE_DATA_BUSY:
>> -					case STATE_DATA_ERROR:
>> -						if (mrq->data->error == -EINPROGRESS)
>> -							mrq->data->error = -ENOMEDIUM;
>> -						/* fall through */
>> -					case STATE_SENDING_STOP:
>> -						if (mrq->stop)
>> -							mrq->stop->error = -ENOMEDIUM;
>> -						break;
>> -					}
>> -
>> -					dw_mci_request_end(host, mrq);
>> -				} else {
>> -					list_del(&slot->queue_node);
>> -					mrq->cmd->error = -ENOMEDIUM;
>> -					if (mrq->data)
>> -						mrq->data->error = -ENOMEDIUM;
>> -					if (mrq->stop)
>> -						mrq->stop->error = -ENOMEDIUM;
>> -
>> -					spin_unlock(&host->lock);
>> -					mmc_request_done(slot->mmc, mrq);
>> -					spin_lock(&host->lock);
>> -				}
>> -			}
>> -
>> -			/* Power down slot */
>> -			if (present == 0)
>> -				dw_mci_reset(host);
>> -
>> -			spin_unlock_bh(&host->lock);
>> -
>> -			present = dw_mci_get_cd(mmc);
>> -		}
>> -
>> -		mmc_detect_change(slot->mmc,
>> -			msecs_to_jiffies(host->pdata->detect_delay_ms));
>> -	}
>> -}
>> -
>>  #ifdef CONFIG_OF
>>  /* given a slot id, find out the device node representing that slot */
>>  static struct device_node *dw_mci_of_find_slot_node(struct device *dev, u8 slot)
>> @@ -2289,9 +2223,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>  	dw_mci_init_debugfs(slot);
>>  #endif
>>  
>> -	/* Card initially undetected */
>> -	slot->last_detect_state = 0;
>> -
>>  	return 0;
>>  
>>  err_host_allocated:
>> @@ -2672,17 +2603,10 @@ int dw_mci_probe(struct dw_mci *host)
>>  		host->data_offset = DATA_240A_OFFSET;
>>  
>>  	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
>> -	host->card_workqueue = alloc_workqueue("dw-mci-card",
>> -			WQ_MEM_RECLAIM, 1);
>> -	if (!host->card_workqueue) {
>> -		ret = -ENOMEM;
>> -		goto err_dmaunmap;
>> -	}
>> -	INIT_WORK(&host->card_work, dw_mci_work_routine_card);
>>  	ret = devm_request_irq(host->dev, host->irq, dw_mci_interrupt,
>>  			       host->irq_flags, "dw-mci", host);
>>  	if (ret)
>> -		goto err_workqueue;
>> +		goto err_dmaunmap;
>>  
>>  	if (host->pdata->num_slots)
>>  		host->num_slots = host->pdata->num_slots;
>> @@ -2718,7 +2642,7 @@ int dw_mci_probe(struct dw_mci *host)
>>  	} else {
>>  		dev_dbg(host->dev, "attempted to initialize %d slots, "
>>  					"but failed on all\n", host->num_slots);
>> -		goto err_workqueue;
>> +		goto err_dmaunmap;
>>  	}
>>  
>>  	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
>> @@ -2726,9 +2650,6 @@ int dw_mci_probe(struct dw_mci *host)
>>  
>>  	return 0;
>>  
>> -err_workqueue:
>> -	destroy_workqueue(host->card_workqueue);
>> -
>>  err_dmaunmap:
>>  	if (host->use_dma && host->dma_ops->exit)
>>  		host->dma_ops->exit(host);
>> @@ -2762,8 +2683,6 @@ void dw_mci_remove(struct dw_mci *host)
>>  	mci_writel(host, CLKENA, 0);
>>  	mci_writel(host, CLKSRC, 0);
>>  
>> -	destroy_workqueue(host->card_workqueue);
>> -
>>  	if (host->use_dma && host->dma_ops->exit)
>>  		host->dma_ops->exit(host);
>>  
>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>> index 01b99e8..71d4995 100644
>> --- a/drivers/mmc/host/dw_mmc.h
>> +++ b/drivers/mmc/host/dw_mmc.h
>> @@ -214,7 +214,6 @@ extern int dw_mci_resume(struct dw_mci *host);
>>   *	with CONFIG_MMC_CLKGATE.
>>   * @flags: Random state bits associated with the slot.
>>   * @id: Number of this slot.
>> - * @last_detect_state: Most recently observed card detect state.
>>   */
>>  struct dw_mci_slot {
>>  	struct mmc_host		*mmc;
>> @@ -234,7 +233,6 @@ struct dw_mci_slot {
>>  #define DW_MMC_CARD_PRESENT	0
>>  #define DW_MMC_CARD_NEED_INIT	1
>>  	int			id;
>> -	int			last_detect_state;
>>  };
>>  
>>  struct dw_mci_tuning_data {
>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>> index 0013669..69d0814 100644
>> --- a/include/linux/mmc/dw_mmc.h
>> +++ b/include/linux/mmc/dw_mmc.h
>> @@ -135,7 +135,6 @@ struct dw_mci {
>>  	struct mmc_command	stop_abort;
>>  	unsigned int		prev_blksz;
>>  	unsigned char		timing;
>> -	struct workqueue_struct	*card_workqueue;
>>  
>>  	/* DMA interface members*/
>>  	int			use_dma;
>> @@ -154,7 +153,6 @@ struct dw_mci {
>>  	u32			stop_cmdr;
>>  	u32			dir_status;
>>  	struct tasklet_struct	tasklet;
>> -	struct work_struct	card_work;
>>  	unsigned long		pending_events;
>>  	unsigned long		completed_events;
>>  	enum dw_mci_state	state;
>>
> 

