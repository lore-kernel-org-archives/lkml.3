Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaLCBTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:19:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31862 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLCBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:19:09 -0500
X-AuditID: cbfee691-f79b86d000004a5a-32-547e650ad84a
Message-id: <547E650A.9050807@samsung.com>
Date: Wed, 03 Dec 2014 10:19:06 +0900
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
 <547E6201.1090804@samsung.com>
 <CAD=FV=W5vapWUcWur1my=AJg=wzcQ_n-tMYGVf2qXLatsXGAsA@mail.gmail.com>
In-reply-to: <CAD=FV=W5vapWUcWur1my=AJg=wzcQ_n-tMYGVf2qXLatsXGAsA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkQJcrtS7EoG+6hcXK938ZLR7M28Zm
	MeHydkaLs8sOsln8f/Sa1eLyrjlsFkf+9zNaPDkzk9Hiw/2LzBbH14Y7cHnMbrjI4nHn2h42
	jxuvFjJ59G1Zxeix/do8Zo/Pm+QC2KK4bFJSczLLUov07RK4Muaffs9a8Fypom37PZYGxkVS
	XYycHBICJhJ/ZrQwQdhiEhfurWfrYuTiEBJYyijRvK2XDabo4rf5rBCJRYwSO24eZ4ZwXjNK
	zNy3hRmkildAS+LNplusIDaLgKrE774z7CA2m4COxPZvx8FWiAqESRxqm8cEUS8o8WPyPRYQ
	W0RAU+JZw0uwocwCbcwS94/MA1stLBAv8fD9IUYQW0jgIpPE1mllIDanQLDEr3v/wJYxC6hL
	TJq3iBnClpfYvOYt2CAJgbfsEq9mfWKGuEhA4tvkQ0DbOIASshKbDjBDvCYpcXDFDZYJjGKz
	kNw0C8nYWUjGLmBkXsUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGKGn/z2buIPx/gHrQ4wC
	HIxKPLwWcXUhQqyJZcWVuYcYTYGumMgsJZqcD0wDeSXxhsZmRhamJqbGRuaWZkrivDrSP4OF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MFa+vhP777f3THGP7qX/28r22Jrt9rpmpFh1ZqJv
	jE5elXrT+zXH3G480qk609rgMOPh9uLCI0CXNZ/lTPoZe+lCl6rwkayNM1QfaOot1GbgPDvz
	TvadrVs4PjLGGiWH8J2cGJx24amlZohM+4x6k5vzUlsihC2r5Pt8ldIP6JuobIzskdqixFKc
	kWioxVxUnAgARHk5M8sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgC5Xal2IwcfV+hYr3/9ltHgwbxub
	xYTL2xktzi47yGbx/9FrVovLu+awWRz5389o8eTMTEaLD/cvMlscXxvuwOUxu+Eii8eda3vY
	PG68Wsjk0bdlFaPH9mvzmD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1
	tLQwV1LIS8xNtVVy8QnQdcvMATpNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYw5gx//R71oLnShVt2++xNDAukupi5OSQEDCRuPhtPiuELSZx4d56ti5GLg4hgUWMEjtu
	HmeGcF4zSszct4UZpIpXQEvizaZbYB0sAqoSv/vOsIPYbAI6Etu/HWcCsUUFwiQOtc1jgqgX
	lPgx+R4LiC0ioCnxrOEl2FBmgTZmiftH5rGBJIQF4iUevj/ECGILCVxkktg6rQzE5hQIlvh1
	7x/YMmYBdYlJ8xYxQ9jyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOP6fSe9gXNVgcYhRgINRiYfXIq4uRIg1say4MvcQowQHs5IIb3YSUIg3JbGy
	KrUoP76oNCe1+BCjKTAIJjJLiSbnA1NTXkm8obGJmZGlkbmhhZGxuZI4742buSFCAumJJanZ
	qakFqUUwfUwcnFINjAYi55ZxrF47c6rXhKxVh3w4vKdzR2veuvB7y7FIBQmu26VBpY4BxrvY
	1tmpTr/y4+ZHnsv212eHm91XbZgiWnle9tzqw81HdmbNkqgTanAXljmeVjFlgpzsHI3lzFFX
	N2m88dZewvpe8Urz5iDu3kOOEnVPPioqBToqvoz90vCh8OPeykfbhZRYijMSDbWYi4oTAQv5
	CgIVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug.

On 12/03/2014 10:12 AM, Doug Anderson wrote:
> Jaehoon,
> 
> On Tue, Dec 2, 2014 at 5:06 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Doug
>>
>> On 12/03/2014 09:36 AM, Doug Anderson wrote:
>>> Jaehoon,
>>>
>>> On Tue, Dec 2, 2014 at 4:17 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>>>> @@ -1245,27 +1246,37 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>>>>>       return present;
>>>>>  }
>>>>>
>>>>> -/*
>>>>> - * Disable lower power mode.
>>>>> - *
>>>>> - * Low power mode will stop the card clock when idle.  According to the
>>>>> - * description of the CLKENA register we should disable low power mode
>>>>> - * for SDIO cards if we need SDIO interrupts to work.
>>>>> - *
>>>>> - * This function is fast if low power mode is already disabled.
>>>>> - */
>>>>> -static void dw_mci_disable_low_power(struct dw_mci_slot *slot)
>>>>> +static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
>>>>>  {
>>>>> +     struct dw_mci_slot *slot = mmc_priv(mmc);
>>>>>       struct dw_mci *host = slot->host;
>>>>> -     u32 clk_en_a;
>>>>> -     const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>>>>>
>>>>> -     clk_en_a = mci_readl(host, CLKENA);
>>>>> +     /*
>>>>> +      * Low power mode will stop the card clock when idle.  According to the
>>>>> +      * description of the CLKENA register we should disable low power mode
>>>>> +      * for SDIO cards if we need SDIO interrupts to work.
>>>>> +      */
>>>>> +     if (mmc->caps & MMC_CAP_SDIO_IRQ) {
>>>>> +             const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>>>>> +             u32 clk_en_a_old;
>>>>> +             u32 clk_en_a;
>>>>>
>>>>> -     if (clk_en_a & clken_low_pwr) {
>>>>> -             mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
>>>>> -             mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
>>>>> -                          SDMMC_CMD_PRV_DAT_WAIT, 0);
>>>>> +             clk_en_a_old = mci_readl(host, CLKENA);
>>>>> +
>>>>> +             if (card->type == MMC_TYPE_SDIO ||
>>>>> +                 card->type == MMC_TYPE_SD_COMBO) {
>>>>> +                     set_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
>>>>> +                     clk_en_a = clk_en_a_old & ~clken_low_pwr;
>>>>> +             } else {
>>>>
>>>> I wonder this point. When entered at this point?
>>>>
>>>> MMC_CAP_SDIO_IRQ is sdio capability. and card->type is also related with SDIO, isn't?
>>>
>>> Right.  As I understand it:
>>>
>>> * You can certainly add MMC_CAP_SDIO_IRQ to an external card slot that
>>> might have an MMC card, and SD card, or an SDIO card.  You still want
>>> the LOW_PWR mode for MMC/SD cards but don't want it for SDIO cards in
>>> that case.
>>
>> Ok, I understood your purpose.
>> Your mean is MMC_CAP_SIDO_IRQ can be set to MMC or SD...not only SDIO card.
>> It's reasonable.
>> But i think it doesn't need to set LOW_PWR_mode for SD/eMMC at here. it should be already set to Low-power mode.
>> And SDIO case should not enter at here.
> 
> Are you sure?  What about if you plug in an SDIO card, then unplug it,
> then plug in an SD card?

Oh.. :) I missed this case. thank you for pointing out.
I considered only non-removable case, it's stupid...

Best Regards,
Jaehoon Chung

> 
>>> * If you don't set MMC_CAP_SDIO_IRQ then presumably you've got some
>>> problem where the SDIO interrupt is broken on your board.  That means
>>> you're using polling mode to find interrupts.  As I understand it that
>>> would allow you to use LOW_PWR since you don't need to detect SDIO
>>> interrupts.  I know on Marvell WiFi modules I tested this seemed to
>>> work OK, but I doubt anyone is really running a production device in
>>> this way.
>>
>> No, we needs to set MMC_CAP_SDIO_IRQ, if i didn't set to it, i will also see the problem.
>> Since I knew which slot is used as SDIO card, i thought MMC_CAP_SDIO_IRQ is set for only sdio card.
>> Then it would be check the twice whether card is SDIO or not.
>>
>> Actually, i didn't test WiFi module with this patch. but concept is not problem.
> 
> Yup, I think you were only thinking about the embedded case where you
> know that an SDIO card will be plugged into the slot.  In the case
> where you have an exposed slot it is certainly possible to expect
> someone might plug in an SD card or an SDIO card.  ...or even a combo
> card!
> 
> -Doug
> 

