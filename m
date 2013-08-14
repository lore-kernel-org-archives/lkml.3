Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab3HNHoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:44:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45790 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369Ab3HNHoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:44:03 -0400
Message-ID: <520B353F.40106@baylibre.com>
Date: Wed, 14 Aug 2013 09:43:59 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 12/22] ARM: dts: Remove '0x's from OMAP2420 H4 DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org> <1374490361-25769-12-git-send-email-lee.jones@linaro.org> <20130813154425.GH15278@lee--X1> <20130814073000.GW7656@atomide.com>
In-Reply-To: <20130814073000.GW7656@atomide.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for that cleanup.

On 14/08/2013 09:30, Tony Lindgren wrote:
> * Lee Jones <lee.jones@linaro.org> [130813 08:51]:
>> Tony, Benoit,
>>
>> Poke
>
> Looks like Benoit's new email address is bcousson@baylibre.com.
> Probably best for Benoit to pick these to avoid merge conflicts.

I've just applied the 7 following patches. Let me know if I missed 
something.

6b9fa1b ARM: dts: Remove '0x's from OMAP5 DTS file
79390b8 ARM: dts: Remove '0x's from OMAP4 DTS file
dd60fef ARM: dts: Remove '0x's from OMAP3430 SDP DTS file
bfef1cb ARM: dts: Remove '0x's from OMAP3 DTS file
5f547ac ARM: dts: Remove '0x's from OMAP3 IGEP0030 DTS file
27939fc ARM: dts: Remove '0x's from OMAP3 IGEP0020 DTS file
62eb4d1 ARM: dts: Remove '0x's from OMAP2420 H4 DTS file

Regards,
Benoit

>
> Regards,
>
> Tony
>
>> On Mon, 22 Jul 2013, Lee Jones wrote:
>>
>>> Cc: Benoît Cousson <b-cousson@ti.com>
>>> Cc: Tony Lindgren <tony@atomide.com>
>>> Cc: linux-omap@vger.kernel.org
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>   arch/arm/boot/dts/omap2420-h4.dts | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap2420-h4.dts b/arch/arm/boot/dts/omap2420-h4.dts
>>> index 224c08f..34cdecb 100644
>>> --- a/arch/arm/boot/dts/omap2420-h4.dts
>>> +++ b/arch/arm/boot/dts/omap2420-h4.dts
>>> @@ -50,15 +50,15 @@
>>>   			label = "bootloader";
>>>   			reg = <0 0x20000>;
>>>   		};
>>> -		partition@0x20000 {
>>> +		partition@20000 {
>>>   			label = "params";
>>>   			reg = <0x20000 0x20000>;
>>>   		};
>>> -		partition@0x40000 {
>>> +		partition@40000 {
>>>   			label = "kernel";
>>>   			reg = <0x40000 0x200000>;
>>>   		};
>>> -		partition@0x240000 {
>>> +		partition@240000 {
>>>   			label = "file-system";
>>>   			reg = <0x240000 0x3dc0000>;
>>>   		};
>>
>> --
>> Lee Jones
>> Linaro ST-Ericsson Landing Team Lead
>> Linaro.org │ Open source software for ARM SoCs
>> Follow Linaro: Facebook | Twitter | Blog
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

