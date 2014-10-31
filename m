Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422742AbaJaBOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:14:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59938 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161430AbaJaBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:14:41 -0400
X-AuditID: cbfee68d-f79296d000004278-e4-5452e27e16ff
Message-id: <5452E27D.5060707@samsung.com>
Date: Fri, 31 Oct 2014 10:14:37 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: addy ke <addy.ke@rock-chips.com>, jh80.chung@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, chris@printf.net,
        ulf.hansson@linaro.org, dinguyen@altera.com, heiko@sntech.de,
        olof@lixom.net, dianders@chromium.org, sonnyrao@chromium.org
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
 <54521AA9.2030700@samsung.com> <5452DBD7.4090908@rock-chips.com>
In-reply-to: <5452DBD7.4090908@rock-chips.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvXNnhoISxyp4xaACURMimyweV/RtEl+MgCQ+oBWHRYGSKeKW
	aEHbuLIaGytWUEBoQEw1QtRGqSiuCLK6VWwVSakJoFEUpZZWE97+c89//vPd5EiwtJ/xk6Rn
	5QhiliwjkPWi6+ZEiSGHLJvjwx8+9Ydqxw8KVMdsLAyee8RAUWcjgostbQw8r25mofXlZQyF
	9goGHJYhBh4MddMwdu0JhhvlPzC02WoR9P1SM3BT85OFsuEkMFh7GKhQV9LQeauMhRZHIYLR
	fgeGqt4OCp70fmWhSFNPw5e3GhpUxhYP+PjsHILh9x0YWusToaRcCheuVrLwuviV028fxHB0
	3ErBxf4mvD6IVxmLWL5OV4f488oOmu8sOE3xtVe+sfz1mmDeoD/O8m977jirysN816N8hu+z
	VVD8H+1dmi+4oUd8Y48O818NCzbN3Oq1ZqeQkZ4riGHrtnuljbY1oOy88H324UZaiZqWnECe
	EsJFkU8tE6xb+5J2c4NTe0mkXBUiv2sMHv9NN28VYHdDg0jzoPWfawiRkYEzzKTLmwsmpYMn
	qUlNc4vJ2ff99KRmuWWk8Xur692H20JMah3l9s8iY6VmejJoDveNImXGIVeBOTsmltcjrunZ
	XBw5Nq6l3eseItL9weoa9+RCSW37cxcg5paSEt0l7NYLyfW6Ly5Ywpk9iVGpYtxMHPleanIm
	SZwNf2K4h92fm0eaa/roIuSrnUKlnRKrnRJbjrAe+QjZydmKHaliRKhClqnYk5UamizPNCDn
	4T2dGDjdhN7cW21CnAQFzvAee7w5XsrIchX7M00o2klRjP18kuXOW83K2RYRGbMcoqOiI5ev
	WBkTONc7wO9nnJRLleUIuwUhWxC3iXsyBIUJURJPPyWiJm7r1tpxCrw7SJ86Ehu5McQWYBwI
	vQ/h9vJPsRHpFFoS90e9d+S4yAR/fqVODBDVu6wZC/XrJEoP7/mrwiyZ8nxW/+bAhWcOc16u
	PGXDfLM6bNGOtfKutPoZ/rpF0tH4d9P6VKcaaH1SXvcBiybhRYxt5eWEuFXR04LG86cH0oo0
	WUQwFhWyv8XbC25zAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsVy+t9jQd26R0EhBjMvC1gs+/+dyaK14xWb
	xYuZJ1gtJlzezmgx/8g5Vouzyw6yWRy/tJjZov/NQlaL/49es1ocfX2VxeLHhlPMFlsWfGe2
	OPdqJaPFjV9trBbbpv9ks5jzIc5i0+NrrBYL25awWFzeNYfN4sj/fkaLTw/+M1ssvX6RyeLU
	9c9sFhOmr2WxeHtnOotF694j7BZPzsxktPhw/yKzxfG14RaTFghZzF23hM3i1sSbQPVvXjBb
	tPx+zGQx/8EOZgdlj9a9E9g81sxbw+gxu+Eii8flvl4mj5XLv7B5bF6h5bFpVSebx51re4C8
	JfUeV040sXrceLWQyePvrP0sHn1bVjF6bL82j9nj8ya5AP6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHGAAKimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzPp1bz1jQaFDx5sN2lgbGHWpdjJwcEgImEtt29TFD2GISF+6t
	Z+ti5OIQEpjOKHHwxWMo5zWjxMdnU1hBqngFtCQmv+hmArFZBFQlpt1/wAJiswnoSGz/dhws
	LioQJnGobR4TRL2gxI/J91hABokIfGGSmLP3NZjDLPCGWeLRrY9g3cICwRIdv2exQKw7xihx
	9eFjsHZOAT2JlRfOsoPYzALqEpPmLWKGsOUlNq95yzyBUWAWki2zkJTNQlK2gJF5FaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwOn0mtYNxZYPFIUYBDkYlHt4Fx4NChFgTy4orcw8xSnAw
	K4nwTtkHFOJNSaysSi3Kjy8qzUktPsRoCgyEicxSosn5wFSfVxJvaGxiZmRpZG5oYWRsriTO
	e6DVOlBIID2xJDU7NbUgtQimj4mDU6qBcVnRQeHleVnTbfebqL3l0pyfvuA8j86vo6sM5r4J
	/R6z4sr98gKtiUnrojoXqATfiSzhdthvP8kic89M29qONBHHoPTgFnlDM+erFT7qT8Mi5tys
	3y6RZn8lJGYi//UjCpW7A7f65vPmH25kO2LReKNmqsOF3936wQHzZzXc1HP0Xn771kVdJZbi
	jERDLeai4kQAMAOB+b0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/31/2014 09:46 AM, addy ke wrote:
> Hi, Jaehoon
> 
> On 2014/10/30 19:02, Jaehoon Chung wrote:
>> Hi, Addy.
>>
>> This patch is conflicted..Could you rebase on latest Ulf's tree?
> I have not found ulf's tree in git.kernel.org.
> I can't 'git clone git://git.kernel.org/pub/scm/linux/kernel/git/ulf/xxx.git'.
> So my patch is based on kernel-3.18.
> I will send patch v2 for this.
> Would you please give me a git url for it?

http://git.linaro.org/git/people/ulf.hansson/mmc.git
I'm checking with next branch.

Best Regards,
Jaehoon Chung

> Thank you.
> 
>>
>> Best Regards,
>> Jaehoon Chung
>>
>> On 10/30/2014 07:50 PM, Addy Ke wrote:
>>> The bit of sdio interrupt is 16 in designware implementation,
>>> but it is 24 in RK3288. This patch add sdio_id0 for the number
>>> of slot0 in the SDIO interrupt registers, which can be set in
>>> platform DT table, such as:
>>> - rockchip,sdio-interrupt-slot0 = <8>;
>>>
>>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>>> ---
>>>  drivers/mmc/host/dw_mmc-rockchip.c | 13 +++++++++++++
>>>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>>>  drivers/mmc/host/dw_mmc.h          |  2 ++
>>>  include/linux/mmc/dw_mmc.h         |  3 +++
>>>  4 files changed, 25 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
>>> index f0c2cb1..54655e7 100644
>>> --- a/drivers/mmc/host/dw_mmc-rockchip.c
>>> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
>>> @@ -65,6 +65,18 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>>>  	}
>>>  }
>>>  
>>> +static int dw_mci_rk3288_parse_dt(struct dw_mci *host)
>>> +{
>>> +	struct device_node *np = host->dev->of_node;
>>> +	int sdio_id0;
>>> +
>>> +	if (!of_property_read_u32(np, "rockchip,sdio-interrupt-slot0",
>>> +				  &sdio_id0))
>>> +		host->sdio_id0 = sdio_id0;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static const struct dw_mci_drv_data rk2928_drv_data = {
>>>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>>>  };
>>> @@ -73,6 +85,7 @@ static const struct dw_mci_drv_data rk3288_drv_data = {
>>>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>>>  	.set_ios		= dw_mci_rk3288_set_ios,
>>>  	.setup_clock    = dw_mci_rk3288_setup_clock,
>>> +	.parse_dt	= dw_mci_rk3288_parse_dt,
>>>  };
>>>  
>>>  static const struct of_device_id dw_mci_rockchip_match[] = {
>>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>>> index 69f0cc6..2ea7467 100644
>>> --- a/drivers/mmc/host/dw_mmc.c
>>> +++ b/drivers/mmc/host/dw_mmc.c
>>> @@ -819,7 +819,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>>  
>>>  		/* enable clock; only low power if no SDIO */
>>>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
>>> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
>>> +		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>>>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>>>  		mci_writel(host, CLKENA, clk_en_a);
>>>  
>>> @@ -1180,10 +1180,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
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
>>> @@ -2035,8 +2035,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
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
>>> @@ -2206,6 +2207,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>>  
>>>  	slot = mmc_priv(mmc);
>>>  	slot->id = id;
>>> +	slot->sdio_id = host->sdio_id0 + id;
>>>  	slot->mmc = mmc;
>>>  	slot->host = host;
>>>  	host->slot[id] = slot;
>>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>>> index 01b99e8..3e966a9 100644
>>> --- a/drivers/mmc/host/dw_mmc.h
>>> +++ b/drivers/mmc/host/dw_mmc.h
>>> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>>>   *	with CONFIG_MMC_CLKGATE.
>>>   * @flags: Random state bits associated with the slot.
>>>   * @id: Number of this slot.
>>> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>>>   * @last_detect_state: Most recently observed card detect state.
>>>   */
>>>  struct dw_mci_slot {
>>> @@ -234,6 +235,7 @@ struct dw_mci_slot {
>>>  #define DW_MMC_CARD_PRESENT	0
>>>  #define DW_MMC_CARD_NEED_INIT	1
>>>  	int			id;
>>> +	int			sdio_id;
>>>  	int			last_detect_state;
>>>  };
>>>  
>>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>>> index 0013669..4c0d3f2 100644
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
>>> @@ -193,6 +194,8 @@ struct dw_mci {
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

