Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbaLCBGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:06:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCBGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:06:13 -0500
X-AuditID: cbfee68e-f79b46d000002b74-0c-547e62028bfa
Message-id: <547E6201.1090804@samsung.com>
Date: Wed, 03 Dec 2014 10:06:09 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/4] mmc: dw_mmc: Cleanup disable of low power mode w/
 SDIO interrupts
References: <1417563767-32181-1-git-send-email-dianders@chromium.org>
 <1417563767-32181-4-git-send-email-dianders@chromium.org>
 <547E569C.3080606@samsung.com>
 <CAD=FV=VU5804WD5SRwr8HAOXwvumkUY+yzjM81oNbPUwwv=nTQ@mail.gmail.com>
In-reply-to: <CAD=FV=VU5804WD5SRwr8HAOXwvumkUY+yzjM81oNbPUwwv=nTQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkRJcpqS7E4MgkK4uV7/8yWjyYt43N
	YsLl7YwWZ5cdZLP4/+g1q8XlXXPYLI7872e0eHJmJqPFh/sXmS2Orw134PKY3XCRxePOtT1s
	HjdeLWTy6NuyitFj+7V5zB6fN8kFsEVx2aSk5mSWpRbp2yVwZezdeoC9YIlcxe21j9gbGI+J
	dTFyckgImEgsXzeJGcIWk7hwbz1bFyMXh5DAUkaJ+1eOM8EUXZl/mQUiMZ1R4lTTVFYI5zWj
	xNOP28CqeAW0JB51/2EFsVkEVCWaz30Fi7MJ6Ehs/wYxSVQgTOJQ2zyoekGJH5PvsYDYIgKa
	Es8aXjKDDGUWaGOWuH9kHhtIQlggXuLh+0OMENteAm1btwpsA6dAsMSkAwfBDmcWUJeYNG8R
	lC0vsXnNW7BJEgIv2SXO3p3OCHGSgMS3yYeA1nEAJWQlNh2AelpS4uCKGywTGMVmITlqFpKx
	s5CMXcDIvIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMEZP/3vWt4Px5gHrQ4wCHIxKPLwW
	cXUhQqyJZcWVuYcYTYGumMgsJZqcD0wEeSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MAp5GknvOFUa1XBxg5hQYffGKaf1sx9t9RTqLrBJau/Wb8pR
	f97SdUjAZqFhePTFOTk1hlxKpxq1Tf/9Oncy7sce/y3zIvN+95+x3zX3ROu505Nzurxc76x4
	0TtTkSXmjdIdnTe7ti9w5L7vmKf97WZUfdba+1IM5TEOxx84iX/5Vvgt726toBJLcUaioRZz
	UXEiAOFH5kPMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoC5TUl2Iwd6FhhYr3/9ltHgwbxub
	xYTL2xktzi47yGbx/9FrVovLu+awWRz5389o8eTMTEaLD/cvMlscXxvuwOUxu+Eii8eda3vY
	PG68Wsjk0bdlFaPH9mvzmD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1
	tLQwV1LIS8xNtVVy8QnQdcvMATpNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYw5ixd+sB9oIlchW31z5ib2A8JtbFyMkhIWAicWX+ZRYIW0ziwr31bF2MXBxCAtMZJU41
	TWWFcF4zSjz9uI0JpIpXQEviUfcfVhCbRUBVovncV7A4m4COxPZvx8FsUYEwiUNt86DqBSV+
	TL4HtkFEQFPiWcNLZpChzAJtzBL3j8xjA0kIC8RLPHx/iBFi20ugbetWgW3gFAiWmHTgIDOI
	zSygLjFp3iIoW15i85q3zBMYBWYhWTILSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgQngGfSOxhXNVgcYhTgYFTi4bWIqwsRYk0sK67MPcQowcGsJMKbZwcU4k1JrKxKLcqP
	LyrNSS0+xGgKDIOJzFKiyfnA5JRXEm9obGJmZGlkbmhhZGyuJM5742ZuiJBAemJJanZqakFq
	EUwfEwenVANjEve6jtvzloaGrrt/mbvMw7W6MONlv5Rg34yVVpFVJiYaKwNDxZ8cMVw9rb9b
	P4vbISRx7sJEWzdHqeijEiXfHf912E4L/3rwybuA+AchbP3+zWJ8pm/U5myPKJPUf7Q0euPk
	mT57JgXPLbnzmVNpp+T0slWcNUeKMk5bbFMUaf+kF3/40yolluKMREMt5qLiRAAJ3ChtFgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug

On 12/03/2014 09:36 AM, Doug Anderson wrote:
> Jaehoon,
> 
> On Tue, Dec 2, 2014 at 4:17 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> @@ -1245,27 +1246,37 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>>>       return present;
>>>  }
>>>
>>> -/*
>>> - * Disable lower power mode.
>>> - *
>>> - * Low power mode will stop the card clock when idle.  According to the
>>> - * description of the CLKENA register we should disable low power mode
>>> - * for SDIO cards if we need SDIO interrupts to work.
>>> - *
>>> - * This function is fast if low power mode is already disabled.
>>> - */
>>> -static void dw_mci_disable_low_power(struct dw_mci_slot *slot)
>>> +static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
>>>  {
>>> +     struct dw_mci_slot *slot = mmc_priv(mmc);
>>>       struct dw_mci *host = slot->host;
>>> -     u32 clk_en_a;
>>> -     const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>>>
>>> -     clk_en_a = mci_readl(host, CLKENA);
>>> +     /*
>>> +      * Low power mode will stop the card clock when idle.  According to the
>>> +      * description of the CLKENA register we should disable low power mode
>>> +      * for SDIO cards if we need SDIO interrupts to work.
>>> +      */
>>> +     if (mmc->caps & MMC_CAP_SDIO_IRQ) {
>>> +             const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>>> +             u32 clk_en_a_old;
>>> +             u32 clk_en_a;
>>>
>>> -     if (clk_en_a & clken_low_pwr) {
>>> -             mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
>>> -             mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
>>> -                          SDMMC_CMD_PRV_DAT_WAIT, 0);
>>> +             clk_en_a_old = mci_readl(host, CLKENA);
>>> +
>>> +             if (card->type == MMC_TYPE_SDIO ||
>>> +                 card->type == MMC_TYPE_SD_COMBO) {
>>> +                     set_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
>>> +                     clk_en_a = clk_en_a_old & ~clken_low_pwr;
>>> +             } else {
>>
>> I wonder this point. When entered at this point?
>>
>> MMC_CAP_SDIO_IRQ is sdio capability. and card->type is also related with SDIO, isn't?
> 
> Right.  As I understand it:
> 
> * You can certainly add MMC_CAP_SDIO_IRQ to an external card slot that
> might have an MMC card, and SD card, or an SDIO card.  You still want
> the LOW_PWR mode for MMC/SD cards but don't want it for SDIO cards in
> that case.

Ok, I understood your purpose.
Your mean is MMC_CAP_SIDO_IRQ can be set to MMC or SD...not only SDIO card.
It's reasonable.
But i think it doesn't need to set LOW_PWR_mode for SD/eMMC at here. it should be already set to Low-power mode.
And SDIO case should not enter at here.

> 
> * If you don't set MMC_CAP_SDIO_IRQ then presumably you've got some
> problem where the SDIO interrupt is broken on your board.  That means
> you're using polling mode to find interrupts.  As I understand it that
> would allow you to use LOW_PWR since you don't need to detect SDIO
> interrupts.  I know on Marvell WiFi modules I tested this seemed to
> work OK, but I doubt anyone is really running a production device in
> this way.

No, we needs to set MMC_CAP_SDIO_IRQ, if i didn't set to it, i will also see the problem.
Since I knew which slot is used as SDIO card, i thought MMC_CAP_SDIO_IRQ is set for only sdio card.
Then it would be check the twice whether card is SDIO or not.

Actually, i didn't test WiFi module with this patch. but concept is not problem.

Best Regards,
Jaehoon Chung

> 
> 
> Basically I was trying to mirror the functionality of the old code as
> closely as possible.  In the old code if you were using polling mode
> then dw_mci_enable_sdio_irq() should never be called and you'd never
> go out of low power mode.
> 
> -Doug
> 

