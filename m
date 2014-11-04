Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaKDCOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:14:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13096 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaKDCOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:14:20 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d1-545836796ff0
Message-id: <54583678.5020501@samsung.com>
Date: Tue, 04 Nov 2014 11:14:16 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: addy ke <addy.ke@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org
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
 <5457440E.3070002@samsung.com> <545757B3.30208@rock-chips.com>
In-reply-to: <545757B3.30208@rock-chips.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRjld3/3XudIuq1pv6QHLSqyNJ/rCysCKW4QET2toFp2U8nH2FWr
	P6IV2guaUyNz5WPm0mSVbZGSSbosH1mk5kwzrawsNajssYhad63A/87hO98554NPhhXPmEBZ
	YkqaoEvRJKlYOW1VRorBB9WxG0OzK5Rwyf2dgqwTwyy8K2hmwNhZjaC48REDDy81sNDUcRFD
	9qiZAferEQbujXTR4KpqxXCj5DuGR8OXEdzM/8HChY87wDboZMB8rIyGzlsXWGh0ZyP4/MKN
	wdLdTkFr9xgLxvwrNHzoy6chq67RB163FSD4ONCOoenKFsgtUUDh1TIWenN6JP3oOwyZPwcp
	KH5Rg1eo+Kw6I8tbi6yIP69vp/lOw2mKv1z+heXtFUG8rfIky/c5b0us7DD/pPkowz8dNlP8
	L9MdmjfcqER8tbMI82O2GesmbpMv3SMkJWYIukXLd8kTLNdPIG1W6AHD0ACjRzlzTyFfGeEi
	yVBHMe3FAeRx/zX2FJLLFJwFkZ/2Vuq/qPFTl493UIqIvcpMeckIIkOnvyKPyo8LIgWdBsaD
	aW4OabEcwR7McgtJ9bemv07+3GbiOFZEefWTiCuvn/YYKbleijTojyAPwdwwJm3H83w8qsnS
	Rma961+pu1JclXfgK9mWdwz+jcbcPJJbVIq9eCaxWz9gzwLhnL6kp7aM8nbiyLc8h5QnkwbT
	ia0ee4+bShoqntJGFGAa18o0ztY0zrYE4UrkL2jjtOLueF14iKhJFtNT4kPiUpNtSPq5B7/f
	GmpQT320A3EypJrgFzs1dqOC0WSIB5MdKEpqkYMD/eNSpTdNSdsZFqEOh6jIqIjwxUvUqil+
	uwJ/bFBw8Zo0YZ8gaAXdTl16kiA6ECXzDdSjKfYWs3bBgHXd3v6MHmfOvoHVwSuVZzXdJoAV
	uvJM19HZa6JHM++7JtWp29Ux7i556KYYhfJ6W0bCek1wX9+0tbXLagpfrif7TfNXOku3z0lc
	GPPenort5qjs+q3Th4y1KtFyRvk86Vb6mPtQkHLV3fOHrGa/6Fmu3MRzYW/y9CpaTNCEBWGd
	qPkDrgOZJW4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsVy+t9jAd1Ks4gQg+VT2CyW/f/OZNHa8YrN
	4sXME6wWEy5vZ7SYf+Qcq8XZZQfZLI5fWsxs0f9mIavF/0evWS2Ovr7KYvFjwylmiy0LvjNb
	nHu1ktFi2/SfbBZzPsRZbHp8jdViYdsSFovLu+awWRz5389o8enBf2aLpdcvMlmcuv6ZzWLC
	9LUsFm/vTGexaN17hN3iyZmZjBYf7l9ktji+Ntxi0gIhi7nrlrBZ3Jp4E6j+zQtmi5bfj5ks
	5j/Yweyg5NG6dwKbx5p5axg9ZjdcZPG43NfL5LFy+Rc2j80rtDw2repk87hzbQ+Qt6Te48qJ
	JlaPG68WMnn8nbWfxaNvyypGj+3X5jF7fN4kF8Af1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQMMOyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYQ1jxtKNHYwFrQYVfc/vszYwTlTrYuTkkBAwkTjy8So7hC0mceHeerYuRi4O
	IYFFjBKbNyxkgnBeM0o87/3KCFLFK6AlMfNyHyuIzSKgKnFyaSMziM0moCOx/dtxJhBbVCBM
	4lDbPCaIekGJH5PvsYAMEhG4xSRxsKGREcRhFnjFLHGmfTLYbmGgjpYDP6B2HwZatwEiwQk0
	dvmlx2CrmQXUJSbNW8QMYctLbF7zlnkCo8AsJFtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzgJPpMagfjygaLQ4wCHIxKPLwRkhEhQqyJZcWVuYcYJTiYlUR4Z/0ODxHi
	TUmsrEotyo8vKs1JLT7EaAoMhInMUqLJ+cAEn1cSb2hsYmZkaWRuaGFkbK4kznug1TpQSCA9
	sSQ1OzW1ILUIpo+Jg1OqgVG3uGzGtL2/vtevevOlK9Wk9SPzx/jTuSt8amukCq94rl/0yPUR
	57LEfZPcvPoOWVxf9Of564gJsxd+rrzTtnWm2oG7ytEhy2sfVke/96y/IbTjfqTQ7cg5htz+
	fz4l6l1R6i/f9OTF2mORLsbvz04yjUzf//JI+OlHhnlzsjJct7wXW3Nb5bm6EktxRqKhFnNR
	cSIA8LF5WbgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear, Addy.

On 11/03/2014 07:23 PM, addy ke wrote:
> Hi, Jaehoo
> 
> On 2014/11/3 16:59, Jaehoon Chung wrote:
>> Hi, Addy.
>>
>> On 11/03/2014 10:20 AM, Addy Ke wrote:
>>> The bit of sdio interrupt is 16 in designware implementation,
>>> but it is 24 on Rockchip SoCs.This patch add sdio_id0 for the
>>> number of slot0 in the SDIO interrupt registers.
>>>
>>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>>> ---
>>> Changes in v2:
>>> - rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next branch
>>> Changes in v3:
>>> - Remove dts for sdio_id0, just replace this with 8, suggested by Doug
>>> - Change to support all Rockchip Socs, suggested by Heiko
>>>
>>>  drivers/mmc/host/dw_mmc-rockchip.c | 10 ++++++++++
>>>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>>>  drivers/mmc/host/dw_mmc.h          |  2 ++
>>>  include/linux/mmc/dw_mmc.h         |  3 +++
>>>  4 files changed, 22 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
>>> index bbb4ec3..b997c8f 100644
>>> --- a/drivers/mmc/host/dw_mmc-rockchip.c
>>> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
>>> @@ -68,14 +68,24 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>>>  	}
>>>  }
>>>  
>>> +static int dw_mci_rockchip_parse_dt(struct dw_mci *host)
>>> +{
>>> +	/* It is slot 8 on Rockchip SoCs */
>>> +	host->sdio_id0 = 8;
>>> +
>>> +	return 0;
>>> +}
>>
>> Well, function is "__parse_dt__", but this function don't parse anything.
>> If All rockchip soc is supported, i think that it can be located to other place.
>>
> Can add it in "init" function? like this:
> int dw_mci_rockchip_init(struct dw_mci *host)
> {
> 	/* It is slot 8 on Rockchip SoCs */
> 	host->sdio_id0 = 8;
> 
> 	return 0;
> }
> static const struct dw_mci_drv_data xxxx {
>     ....
>     .init = dw_mci_rockchip_init,
> };

I think good this solution is used. "init-hook" can be also used in future.
When you resend the patch, i will reply with my-ack.

Best Regards,
Jaehoon Chung

> 
> 
>> Best Regards,
>> Jaehoon Chung
>>
>>> +
>>>  static const struct dw_mci_drv_data rk2928_drv_data = {
>>>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>>> +	.parse_dt	= dw_mci_rockchip_parse_dt,
>>>  };
>>>  
>>>  static const struct dw_mci_drv_data rk3288_drv_data = {
>>>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>>>  	.set_ios		= dw_mci_rk3288_set_ios,
>>>  	.setup_clock    = dw_mci_rk3288_setup_clock,
>>> +	.parse_dt	= dw_mci_rockchip_parse_dt,
>>>  };
>>>  
>>>  static const struct of_device_id dw_mci_rockchip_match[] = {
>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>> index bb46b1b..a633b58 100644
>>> --- a/drivers/mmc/host/dw_mmc.c
>>> +++ b/drivers/mmc/host/dw_mmc.c
>>> @@ -823,7 +823,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>>  
>>>  		/* enable clock; only low power if no SDIO */
>>>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
>>> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
>>> +		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>>>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>>>  		mci_writel(host, CLKENA, clk_en_a);
>>>  
>>> @@ -1184,10 +1184,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>>>  		dw_mci_disable_low_power(slot);
>>>  
>>>  		mci_writel(host, INTMASK,
>>> -			   (int_mask | SDMMC_INT_SDIO(slot->id)));
>>> +			   (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
>>>  	} else {
>>>  		mci_writel(host, INTMASK,
>>> -			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
>>> +			   (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
>>>  	}
>>>  }
>>>  
>>> @@ -2056,8 +2056,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>>  		/* Handle SDIO Interrupts */
>>>  		for (i = 0; i < host->num_slots; i++) {
>>>  			struct dw_mci_slot *slot = host->slot[i];
>>> -			if (pending & SDMMC_INT_SDIO(i)) {
>>> -				mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
>>> +			if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
>>> +				mci_writel(host, RINTSTS,
>>> +					   SDMMC_INT_SDIO(slot->sdio_id));
>>>  				mmc_signal_sdio_irq(slot->mmc);
>>>  			}
>>>  		}
>>> @@ -2145,6 +2146,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>>  
>>>  	slot = mmc_priv(mmc);
>>>  	slot->id = id;
>>> +	slot->sdio_id = host->sdio_id0 + id;
>>>  	slot->mmc = mmc;
>>>  	slot->host = host;
>>>  	host->slot[id] = slot;
>>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>>> index 71d4995..0562f10 100644
>>> --- a/drivers/mmc/host/dw_mmc.h
>>> +++ b/drivers/mmc/host/dw_mmc.h
>>> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>>>   *	with CONFIG_MMC_CLKGATE.
>>>   * @flags: Random state bits associated with the slot.
>>>   * @id: Number of this slot.
>>> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>>>   */
>>>  struct dw_mci_slot {
>>>  	struct mmc_host		*mmc;
>>> @@ -233,6 +234,7 @@ struct dw_mci_slot {
>>>  #define DW_MMC_CARD_PRESENT	0
>>>  #define DW_MMC_CARD_NEED_INIT	1
>>>  	int			id;
>>> +	int			sdio_id;
>>>  };
>>>  
>>>  struct dw_mci_tuning_data {
>>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>>> index 69d0814..72c319f 100644
>>> --- a/include/linux/mmc/dw_mmc.h
>>> +++ b/include/linux/mmc/dw_mmc.h
>>> @@ -96,6 +96,7 @@ struct mmc_data;
>>>   * @quirks: Set of quirks that apply to specific versions of the IP.
>>>   * @irq_flags: The flags to be passed to request_irq.
>>>   * @irq: The irq value to be passed to request_irq.
>>> + * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
>>>   *
>>>   * Locking
>>>   * =======
>>> @@ -191,6 +192,8 @@ struct dw_mci {
>>>  	bool			vqmmc_enabled;
>>>  	unsigned long		irq_flags; /* IRQ flags */
>>>  	int			irq;
>>> +
>>> +	int			sdio_id0;
>>>  };
>>>  
>>>  /* DMA ops for Internal/External DMAC interface */
>>>
>>
>>
>>
>>
> 
> 

