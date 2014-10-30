Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbaJ3LSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:18:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33485 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646AbaJ3LSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:18:02 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-97-54521e678d17
Message-id: <54521E66.2080300@samsung.com>
Date: Thu, 30 Oct 2014 20:17:58 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>, Addy Ke <addy.ke@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414635679-12565-1-git-send-email-addy.ke@rock-chips.com>
 <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com>
 <CAPDyKFqgNmLbbJpATCqwu0R65xuf=TKP0+pjskGj4xZOjXN8Hw@mail.gmail.com>
In-reply-to: <CAPDyKFqgNmLbbJpATCqwu0R65xuf=TKP0+pjskGj4xZOjXN8Hw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec97znGOpNPKfBtUYIU5urppj3Sn2yEiuwd9yJYdlqZmm0VF
	kEWaGdU0aLm8zPulqTFFLYrZ1BQrTa1ltuxiVOik6DJdYmtzfvDb/32e3/95/w88IiyxMVJR
	dHyioI5XxgayYto4Q6FZrJqza8+yinx/KHYNU5CcOsDCt8xWBrTddQhym9oZeF78mIWWrgIM
	N+x5DLg+DTLQPPiKhpF7bRhqDMMY2gfKEPT8TWGgVudkIevHQTD1WxnISymkoftBFgtNrhsI
	fn5wYSh63UlB2+tfLGh1FTQM2XQ0JD9q8oHPzzIR/HjfiaGlYj9kGCSQXVnIQm/6Gzdv/4bh
	0mg/Bbkf6vG6eXzyIy3LG3OMiL+T1Enz3devUXxZyW+Wry6V8abyKyxvsz50vwrP8y9bLzJ8
	z0AexY/pzTR/vaYc8XXWHMz/Ms3ZMfWAeNURITb6lKBeuuaQ+GhuajJOMMtPF9fep5JQyfw0
	5CsinIJ0pZp9vHomedFXxaYhsUjCFSFS+vYpnYZE45CtMdhb1yGiq7dPQIOINBb8oT1uP05G
	xoayKY+muQUkafQ349Est4jUOVrG6/7cPmJJyaG8/DQycrNv3DuD20oMH7vHeczZxORy+jaP
	ns7tJqmjetr7WRsime9aWE/D190Yyb7Peg1BJCMnH3v1XFJtHMLedXp9ibOBeANxxHHTMrHN
	bGJqmEBmkcelPbQWzdRPiqSfNFU/aaoB4XLkLyREJWgOq9SKJRplnOZkvGpJ1PE4E3If3dN/
	X7T1qK9hpQVxIhQ4xS+4deceCaM8pTkTZ0Gh7hTpWOofddx9p/GJkcvlYSEQqgiVh6wIDwsM
	8BuUOndLOJUyUTgmCAmCOlJ9MlbQWBAl8pUmoRPDMmd2NXEo6kMvFDg2rP8+xX6uLLzhfeTl
	ynZ5VbPh4tlb8qKIC2v7bjcucr0cKQlyYttmR8zcK5WbQmSRxjHV6rtfq6TtEV3TLQEZ+bPO
	2TuOdFz911yReWxv7aUFWQOdWNhStrDfx2zdlY8blVNjSp5YRzem1Ux7En5me625LZDWHFUu
	l2G1Rvkf4yFXOm8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsVy+t9jQd10uaAQg5crOSyW/f/OZNHa8YrN
	4sXME6wWEy5vZ7SYf+Qcq8XZZQfZLI5fWsxs0f9mIavF/0evWS2Ovr7KYvFjwylmiy0LvjNb
	nHu1ktHixq82Vott03+yWcz5EGex6fE1VouFbUtYLC7vmsNmceR/P6PFpwf/mS2WXr/IZHHq
	+mc2iwnT17JYvL0zncWide8RdosnZ2YyWny4f5HZ4vjacItJC4Qs5q5bwmZxa+JNoPo3L5gt
	Wn4/ZrKY/2AHs4OyR+veCWwea+atYfSY3XCRxeNyXy+Tx8rlX9g8Nq/Q8ti0qpPN4861PUDe
	knqPKyeaWD1uvFrI5PF31n4Wj74tqxg9tl+bx+zxeZNcAH9UA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDjAAlRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZ8ztamQv2G1cs27aTqYFxuUoXIweHhICJxJ3Dml2MnECmmMSF
	e+vZuhi5OIQEpjNKTN/xBsp5zShxePFXFpAqXgEtib9v5zKB2CwCqhINv7+wgthsAjoS278d
	B4uLCoRJHGqbxwRRLyjxY/I9sF4RAS+JBQ8vg9UzC9zhkmif6ANiCwsES3T8nsUCsewUo8TM
	u8fZQBKcQIkfc3eyQTSoS0yat4gZwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjBifSZ9A7GVQ0WhxgFOBiVeHg1TgSGCLEmlhVX5h5ilOBgVhLh
	XS0WFCLEm5JYWZValB9fVJqTWnyI0RQYBBOZpUST84FJPq8k3tDYxMzI0sjc0MLI2FxJnPdg
	q3WgkEB6YklqdmpqQWoRTB8TB6dUA+N0wynOzktfqf/f9+A0S4ncNLkDVZ4mF+t59ni+VGLe
	7c79XdvLS8JQjKFZy7TIXUKhWEO5r+XnvRCZxeJ8zUtXWz3ep9QcrOPOrC4yVWhBAuMHf/v7
	vPoeAQUP2/cpfSpqCxCJatj+KaZkms3Khjvsqyb4i2rIzMp6ndhoX3DqwRbjeTwNSizFGYmG
	WsxFxYkAwPlqRLoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 08:11 PM, Ulf Hansson wrote:
> On 30 October 2014 11:50, Addy Ke <addy.ke@rock-chips.com> wrote:
>> The bit of sdio interrupt is 16 in designware implementation,
>> but it is 24 in RK3288. This patch add sdio_id0 for the number
>> of slot0 in the SDIO interrupt registers, which can be set in
>> platform DT table, such as:
>> - rockchip,sdio-interrupt-slot0 = <8>;
> 
> No, this shouldn't be information in DT.
> 
> Instead this can be kept in the driver, depending on what version of
> the mmc controller that is being used. Right!?

sdio-interrupt slot doesn't depend on IP version.
maybe it depends on rock-chip board.

Best Regards,
Jaehoon Chung

> 
> Kind regards
> Uffe
> 
>>
>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>> ---
>>  drivers/mmc/host/dw_mmc-rockchip.c | 13 +++++++++++++
>>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>>  drivers/mmc/host/dw_mmc.h          |  2 ++
>>  include/linux/mmc/dw_mmc.h         |  3 +++
>>  4 files changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
>> index f0c2cb1..54655e7 100644
>> --- a/drivers/mmc/host/dw_mmc-rockchip.c
>> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
>> @@ -65,6 +65,18 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>>         }
>>  }
>>
>> +static int dw_mci_rk3288_parse_dt(struct dw_mci *host)
>> +{
>> +       struct device_node *np = host->dev->of_node;
>> +       int sdio_id0;
>> +
>> +       if (!of_property_read_u32(np, "rockchip,sdio-interrupt-slot0",
>> +                                 &sdio_id0))
>> +               host->sdio_id0 = sdio_id0;
>> +
>> +       return 0;
>> +}
>> +
>>  static const struct dw_mci_drv_data rk2928_drv_data = {
>>         .prepare_command        = dw_mci_rockchip_prepare_command,
>>  };
>> @@ -73,6 +85,7 @@ static const struct dw_mci_drv_data rk3288_drv_data = {
>>         .prepare_command        = dw_mci_rockchip_prepare_command,
>>         .set_ios                = dw_mci_rk3288_set_ios,
>>         .setup_clock    = dw_mci_rk3288_setup_clock,
>> +       .parse_dt       = dw_mci_rk3288_parse_dt,
>>  };
>>
>>  static const struct of_device_id dw_mci_rockchip_match[] = {
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index 69f0cc6..2ea7467 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -819,7 +819,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>
>>                 /* enable clock; only low power if no SDIO */
>>                 clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
>> -               if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
>> +               if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>>                         clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>>                 mci_writel(host, CLKENA, clk_en_a);
>>
>> @@ -1180,10 +1180,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>>                 dw_mci_disable_low_power(slot);
>>
>>                 mci_writel(host, INTMASK,
>> -                          (int_mask | SDMMC_INT_SDIO(slot->id)));
>> +                          (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
>>         } else {
>>                 mci_writel(host, INTMASK,
>> -                          (int_mask & ~SDMMC_INT_SDIO(slot->id)));
>> +                          (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
>>         }
>>  }
>>
>> @@ -2035,8 +2035,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>                 /* Handle SDIO Interrupts */
>>                 for (i = 0; i < host->num_slots; i++) {
>>                         struct dw_mci_slot *slot = host->slot[i];
>> -                       if (pending & SDMMC_INT_SDIO(i)) {
>> -                               mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
>> +                       if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
>> +                               mci_writel(host, RINTSTS,
>> +                                          SDMMC_INT_SDIO(slot->sdio_id));
>>                                 mmc_signal_sdio_irq(slot->mmc);
>>                         }
>>                 }
>> @@ -2206,6 +2207,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>
>>         slot = mmc_priv(mmc);
>>         slot->id = id;
>> +       slot->sdio_id = host->sdio_id0 + id;
>>         slot->mmc = mmc;
>>         slot->host = host;
>>         host->slot[id] = slot;
>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>> index 01b99e8..3e966a9 100644
>> --- a/drivers/mmc/host/dw_mmc.h
>> +++ b/drivers/mmc/host/dw_mmc.h
>> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>>   *     with CONFIG_MMC_CLKGATE.
>>   * @flags: Random state bits associated with the slot.
>>   * @id: Number of this slot.
>> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>>   * @last_detect_state: Most recently observed card detect state.
>>   */
>>  struct dw_mci_slot {
>> @@ -234,6 +235,7 @@ struct dw_mci_slot {
>>  #define DW_MMC_CARD_PRESENT    0
>>  #define DW_MMC_CARD_NEED_INIT  1
>>         int                     id;
>> +       int                     sdio_id;
>>         int                     last_detect_state;
>>  };
>>
>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>> index 0013669..4c0d3f2 100644
>> --- a/include/linux/mmc/dw_mmc.h
>> +++ b/include/linux/mmc/dw_mmc.h
>> @@ -96,6 +96,7 @@ struct mmc_data;
>>   * @quirks: Set of quirks that apply to specific versions of the IP.
>>   * @irq_flags: The flags to be passed to request_irq.
>>   * @irq: The irq value to be passed to request_irq.
>> + * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
>>   *
>>   * Locking
>>   * =======
>> @@ -193,6 +194,8 @@ struct dw_mci {
>>         bool                    vqmmc_enabled;
>>         unsigned long           irq_flags; /* IRQ flags */
>>         int                     irq;
>> +
>> +       int                     sdio_id0;
>>  };
>>
>>  /* DMA ops for Internal/External DMAC interface */
>> --
>> 1.8.3.2
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

