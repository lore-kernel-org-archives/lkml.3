Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaKSBWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:22:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9155 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaKSBWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:22:38 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-e4-546bf0d32561
Content-transfer-encoding: 8BIT
Message-id: <546BF0D2.3000600@samsung.com>
Date: Wed, 19 Nov 2014 10:22:26 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: Addy <addy.ke@rock-chips.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, chris@printf.net,
        ulf.hansson@linaro.org, dinguyen@altera.com, heiko@sntech.de,
        olof@lixom.net, dianders@chromium.org, sonnyrao@chromium.org,
        amstan@chromium.org
Cc: huangtao@rock-chips.com, devicetree@vger.kernel.org, hl@rock-chips.com,
        linux-doc@vger.kernel.org, yzq@rock-chips.com, zyw@rock-chips.com,
        zhangqing@rock-chips.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kever.yang@rock-chips.com,
        lintao@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, zhenfu.fang@rock-chips.com, chenfen@rock-chips.com,
        cf@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, zyf@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: add quirk for data over interrupt timeout
References: <1415970338-2637-1-git-send-email-addy.ke@rock-chips.com>
 <54660120.50305@samsung.com> <546A93B0.1040506@rock-chips.com>
In-reply-to: <546A93B0.1040506@rock-chips.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxbZRTHfe5z76WQEe/KwGcMRBvIElTKtoLHORwxMd5liZoJLhp1lnpl
	s8CgF8j2yW6OKk0G5SXiOl6KA+RVoMMVt+HWylIyYA5QXszCEJgplDGUrQzd6HrpB/n2Oye/
	8zznnxwZlk8x4bIjWbmCLkudoWCD6NYtqpyXRpa0KfETHfHQ4F2hQO8qZaDg63kWXGf6GDCN
	2BDU9N5gYLDBzoJz+ByG4oVaBrzTbgauuX+n4WHHdQxdlhUMN+abEIz/a2DgQsUqC5VLH4N1
	ZpSBWkMdDSMXK1no9RYj+GfKi6F+bIiC62PLLJgq2mi4e6uChoKe3gCYHTiDYOn2EAZn20Eo
	tcih6oc6Fv4omfD5Cy4Mp/6boaBmqhsnR/MFPSaWb61uRfxZ/RDNjxSdpvim7++z/PnGWN7a
	XMjyt0Yv+6q6L/jf+k4y/Ph8LcU/Nl+h+aKuZsTbRqsxv2x99p2nPwja86mQcSRf0Clf+yTo
	cN/ibTbbs/fYJZeL1aNhpREFyginIi2lJ2k/h5Gbk+2sxHKuHpHpCyojkq07lV5kREG+dgUi
	v67WIckJ5jaTh2WTtORgLor0DmulNua2k9Lq77DfdyNyv62F8fuxpGruXoDENBdDKh/0Y4lZ
	7kVi8zgpiUO594jDUE1Jw1u4bzC5ZO5afwlz85gMfFW2Ph3C7Sd/Puhm/JsaEDm1/L7EgVwc
	OX/RGCANEG4xkNQ4yxn/dxzxlDlof5xIYr2K/Ym3EnvjOG1CYeYNgcz/BzJvCGRBuBmFCtma
	bDEtXaeKE9WZYl5WepzmaKYV+Q6vf+0vUzeavPqqA3EypNgUbHJrU+SMOl88nulACb4lSnB4
	qOao71azcg/t2JW4ExJUCbt2vvxKouKZYHf46rtyLl2dK2gFIVvQHdLlZQiiA1GywHA9il7Z
	PDX9RmroaMvPIZ/f23P5pyvJlMaY5BWf95wo7nz775WD4rbOKpvlw7l9X0YlONZS79RHvBkz
	mJlzM+3RL4+ee0q/aBno3N9x7ceFpOTIkN2GWbszbUnRPtizPSZa/22hx/66Z1+EVp+kIUJ/
	xFufEVV7k+yj3QfOlr9gC1HmYKWCFg+rd8Rinah+AiLMlBFzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsVy+t9jQd3LH7JDDI71qVgs+/+dyaLhxSRW
	i9aOV2wWL2aeYLWYcHk7o8X8I+dYLc4uO8hmcfzSYmaL/jcLWS3+P3rNanH09VUWix8bTjFb
	bFnwndni3KuVjBY3frWxWmyb/pPNYs6HOItNj6+xWixsW8JicXnXHDaLI//7GS0+PfjPbLH0
	+kUmi1PXP7NZTJi+lsXi7Z3pLBate4+wWzw5M5PR4sP9i8wWx9eGW0xaIGQxd90SNotbE28C
	1b95wWzR8vsxk8X8BzuYHVQ8WvdOYPNYM28No8fshossHpf7epk8Vi7/wuaxeYWWx6ZVnWwe
	d67tAfKW1HtcOdHE6nHj1UImj7+z9rN49G1Zxeix/do8Zo/Pm+QC+KMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgKGopFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcw48e4+W8E3+4rdL16wNTBe0u9i5OCQEDCRmPOfsYuR
	E8gUk7hwbz1bFyMXh5DAdEaJ8z+XgCV4BQQlfky+xwJSzywgL3HkUjZImFlAXWLSvEXMEPWv
	GSW+rF3NClGvJTH35Xt2EJtFQFViztfTzCA2m4COxPZvx5lAbFGBMIlDbfOYQJpFBKYxS+ye
	tQVsErPAK2aJM+2TwbqFBbwlHn7dATZVSKCNUaLlcySIzSmgJ7F5Vxf7BEaBWUgOnIVw4Cwk
	By5gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZxQn0ntYFzZYHGIUYCDUYmH98Xb7BAh
	1sSy4srcQ4wSHMxKIryC3UAh3pTEyqrUovz4otKc1OJDjKZA701klhJNzgcm+7ySeENjEzMj
	SyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYzbzl94yNqrkMdpeOeoA8+BmtVe
	vw9un1S1ROPZrDMJuy/Uz34v8yM0btNDkwkKJgxnZvR1vShyvuRkN2l94iHzI55fOA/+OGG6
	rqd7TVqwn/O78DustrEd7zZbRjs8f5xrsNhLOEPbS0V9TfvHeVeOT3ApyFSZspBFXHCFrWOI
	7rUWIV7/tJVKLMUZiYZazEXFiQBb86V3vgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Addy.

On 11/18/2014 09:32 AM, Addy wrote:
> 
> On 2014年11月14日 21:18, Jaehoon Chung wrote:
>> Hi, Addy.
>>
>> Did you use the DW_MCI_QUIRK_IDMAC_DTO?
>> I'm not sure, but i wonder if you get what result when you use above quirk.
> 
> DW_MCI_QUIRK_IDMAC_DTO is only for version2.0 or below.
>         /*
>          * DTO fix - version 2.10a and below, and only if internal DMA
>          * is configured.
>          */
>         if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO) {
>                 if (!pending &&
>                     ((mci_readl(host, STATUS) >> 17) & 0x1fff))
>                         pending |= SDMMC_INT_DATA_OVER;
>         }
> 
> It meams that if interrupt comes, but pending = 0 && FIFO_COUNT(bit17-29) !=0,
> then force to set SDMMC_INT_DATA_OVER.
> But in our case, FIFO_COUNT = 0 (STATUS register value is 0xad06). This is
> because that the card does not send data to host. So there is no interrupts come,
> and interrupt handle function(dw_mci_interrupt) will not be called. So we need a
> timer to handle this case.
> 
> So I think  SDMMC_INT_DATA_OVER is not suitable for this case, and we need a new
> quirk.
> 
>>
>> And i will check more this patch at next week.
>>
>> Thanks for your efforts.
>>
>> Best Regards,
>> Jaehoon Chung
>>
>> On 11/14/2014 10:05 PM, Addy Ke wrote:
>>> From: Addy <addy.ke@rock-chips.com>
>>>
>>> This patch add a new quirk to notify the driver to teminate
>>> current transfer and report a data timeout to the core,
>>> if data over interrupt does NOT come within the given time.
>>>
>>> dw_mmc call mmc_request_done func to finish transfer depends on
>>> data over interrupt. If data over interrupt does not come in
>>> sending data state, the current transfer will be blocked.
>>>
>>> But this case really exists, when driver reads tuning data from
>>> card on rk3288-pink2 board. I measured waveforms by oscilloscope
>>> and found that card clock was always on and data lines were always
>>> holded high level in sending data state. This is the cause that
>>> card does NOT send data to host.
>>>
>>> According to synopsys designware databook, the timeout counter is
>>> started only after the card clock is stopped.
>>>
>>> So if card clock is always on, data read timeout interrupt will NOT come,
>>> and if data lines are always holded high level, all data-related
>>> interrupt such as start-bit error, data crc error, data over interrupt,
>>> end-bit error, and so on, will NOT come too.
>>>
>>> So driver can't get the current state, it can do nothing but wait for.
>>>
>>> This patch is based on https://patchwork.kernel.org/patch/5227941/
>>>
>>> Signed-off-by: Addy <addy.ke@rock-chips.com>
>>> ---
>>>   drivers/mmc/host/dw_mmc.c  | 47 +++++++++++++++++++++++++++++++++++++++++++++-
>>>   include/linux/mmc/dw_mmc.h |  5 +++++
>>>   2 files changed, 51 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>> index b4c3044..3960fc3 100644
>>> --- a/drivers/mmc/host/dw_mmc.c
>>> +++ b/drivers/mmc/host/dw_mmc.c
>>> @@ -1448,6 +1448,17 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
>>>       return data->error;
>>>   }
>>>   +static inline void dw_mci_dto_start_monitor(struct dw_mci *host)
>>> +{
>>> +    unsigned int data_tmout_clks;
>>> +    unsigned int data_tmout_ms;
>>> +
>>> +    data_tmout_clks = (mci_readl(host, TMOUT) >> 8);
>>> +    data_tmout_ms = (data_tmout_clks * 1000 / host->bus_hz) + 250;

What's 250? And how about using the DIV_ROUND_UP? 

>>> +
>>> +    mod_timer(&host->dto_timer, jiffies + msecs_to_jiffies(data_tmout_ms));
>>> +}
>>> +
>>>   static void dw_mci_tasklet_func(unsigned long priv)
>>>   {
>>>       struct dw_mci *host = (struct dw_mci *)priv;
>>> @@ -1522,8 +1533,11 @@ static void dw_mci_tasklet_func(unsigned long priv)
>>>               }
>>>                 if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
>>> -                        &host->pending_events))
>>> +                        &host->pending_events)) {
>>> +                if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
>>> +                    dw_mci_dto_start_monitor(host);

if timer is starting at only here, dw_mci_dto_start_monitor() doesn't need.

>>>                   break;
>>> +            }
>>>                 set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
>>>   @@ -2115,6 +2129,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>>           }
>>>             if (pending & SDMMC_INT_DATA_OVER) {
>>> +            if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
>>> +                del_timer(&host->dto_timer);
>>> +
>>>               mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
>>>               if (!host->data_status)
>>>                   host->data_status = pending;
>>> @@ -2502,6 +2519,28 @@ ciu_out:
>>>       return ret;
>>>   }
>>>   +static void dw_mci_dto_timer(unsigned long arg)
>>> +{
>>> +    struct dw_mci *host = (struct dw_mci *)arg;

I prefer to use the "data" instead of "arg"

>>> +
>>> +    switch (host->state) {
>>> +    case STATE_SENDING_DATA:
>>> +    case STATE_DATA_BUSY:
>>> +        /*
>>> +        * If data over interrupt does NOT come in sending data state,
>>> +        * we should notify the driver to teminate current transfer
teminate/terminate?

>>> +        * and report a data timeout to the core.
>>> +        */
>>> +        host->data_status = SDMMC_INT_DRTO;
>>> +        set_bit(EVENT_DATA_ERROR, &host->pending_events);
>>> +        set_bit(EVENT_DATA_COMPLETE, &host->pending_events);

Dose it need to set EVENT_DATA_COMPLETE?

>>> +        tasklet_schedule(&host->tasklet);
>>> +        break;
>>> +    default:
>>> +        break;
>>> +    }
>>> +}
>>> +
>>>   #ifdef CONFIG_OF
>>>   static struct dw_mci_of_quirks {
>>>       char *quirk;
>>> @@ -2513,6 +2552,9 @@ static struct dw_mci_of_quirks {
>>>       }, {
>>>           .quirk    = "disable-wp",
>>>           .id    = DW_MCI_QUIRK_NO_WRITE_PROTECT,
>>> +    }, {
>>> +        .quirk    = "dto-timer",
>>> +        .id    = DW_MCI_QUIRK_DTO_TIMER,
>>>       },

Well, this is s/w timer, so i'm not sure this can be merged into dt-file.
If this is generic solution, we can add s/w timer by default. how about?

Best Regards,
Jaehoon Chung

>>>   };
>>>   @@ -2654,6 +2696,9 @@ int dw_mci_probe(struct dw_mci *host)
>>>         spin_lock_init(&host->lock);
>>>       INIT_LIST_HEAD(&host->queue);
>>> +    if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
>>> +        setup_timer(&host->dto_timer,
>>> +                dw_mci_dto_timer, (unsigned long)host);
>>>         /*
>>>        * Get the host data width - this assumes that HCON has been set with
>>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>>> index 42b724e..2477813 100644
>>> --- a/include/linux/mmc/dw_mmc.h
>>> +++ b/include/linux/mmc/dw_mmc.h
>>> @@ -98,6 +98,7 @@ struct mmc_data;
>>>    * @irq_flags: The flags to be passed to request_irq.
>>>    * @irq: The irq value to be passed to request_irq.
>>>    * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
>>> + * @dto_timer: Timer for data over interrupt timeout.
>>>    *
>>>    * Locking
>>>    * =======
>>> @@ -196,6 +197,8 @@ struct dw_mci {
>>>       int            irq;
>>>         int            sdio_id0;
>>> +
>>> +    struct timer_list    dto_timer;
>>>   };
>>>     /* DMA ops for Internal/External DMAC interface */
>>> @@ -220,6 +223,8 @@ struct dw_mci_dma_ops {
>>>   #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION    BIT(3)
>>>   /* No write protect */
>>>   #define DW_MCI_QUIRK_NO_WRITE_PROTECT        BIT(4)
>>> +/* Timer for data over interrupt timeout */
>>> +#define DW_MCI_QUIRK_DTO_TIMER            BIT(5)
>>>     /* Slot level quirks */
>>>   /* This slot has no write protect */
>>>
>>
>>
>>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

