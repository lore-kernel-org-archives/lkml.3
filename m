Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaBQI4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:56:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBQI4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:56:31 -0500
MIME-Version: 1.0
In-Reply-To: <52FDF5FA.4000909@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
 <1391750695-27447-1-git-send-email-ch.naveen@samsung.com> <52FD552E.8040008@samsung.com>
 <52FDF5FA.4000909@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Mon, 17 Feb 2014 14:26:10 +0530
Message-ID: <CAHfPSqAaxuS1S5Buy2FUqvy7_8zGGYp5Dc2mK4bogxe1eH1VJA@mail.gmail.com>
Subject: Re: [PATCH 6/9 v6] ARM: dts: exynos5250/5420: add dt node for sss module
To: Tomasz Figa <t.figa@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On 14 February 2014 16:24, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Kukjin,
>
>
> On 14.02.2014 00:28, Kukjin Kim wrote:
>>
>> On 02/07/14 14:24, Naveen Krishna Chatradhi wrote:
>>>
>>> This patch adds the device tree node for SSS module
>>> found on Exynos5420 and Exynos5250
>>>
>>> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
>>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>> TO:<linux-samsung-soc@vger.kernel.org>
>>> CC: Kukjin Kim<kgene.kim@samsung.com>
>>> CC:<linux-crypto@vger.kernel.org>
>>> ---
>>> changes since v5:
>>> 1. Added Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>>
>>>   arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>>>   arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>>>   2 files changed, 18 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>>> b/arch/arm/boot/dts/exynos5250.dtsi
>>> index b7dec41..46b04e8 100644
>>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>>> @@ -706,4 +706,12 @@
>>>           io-channel-ranges;
>>>           status = "disabled";
>>>       };
>>> +
>>> +    sss@10830000 {
>>> +        compatible = "samsung,exynos4210-secss";
>>> +        reg =<0x10830000 0x10000>;
>>> +        interrupts =<0 112 0>;
>>> +        clocks =<&clock 348>;
>>> +        clock-names = "secss";
>>> +    };
>>>   };
>>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi
>>> b/arch/arm/boot/dts/exynos5420.dtsi
>>> index 8db792b..b503e96 100644
>>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>>> @@ -652,4 +652,14 @@
>>>           clocks =<&clock 319>,<&clock 318>;
>>>           clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>>>       };
>>> +
>>> +    sss@10830000 {
>>> +        compatible = "samsung,exynos4210-secss";
>>> +        reg =<0x10830000 0x10000>;
>>> +        interrupts =<0 112 0>;
>>> +        clocks =<&clock 471>;
>>> +        clock-names = "secss";
>>> +        samsung,power-domain =<&g2d_pd>;
>>> +    };
>>> +
>>>   };
>>
>>
>> Applied, thanks.
>>
>> BTW, I think the numbering is strange...maybe I missed something?
>> [PATCH 5/5], [PATCH 5/6 V2], [PATCH 6/8 V3] and this [PATCH 6/9 V6]
>
>
> I would wait with applying any patches from this series until they are acked
> by crypto subsystem maintainer and DT bindings by DT maintainers.
>
> I'd like Naveen to resend this series in separate thread, with proper
> message threading, so we can make sure that we are not missing anything.
> Naveen, please also add
Sure, i will respin the v6 version of this patchset without using the
In-Reply-To option.
>
> David S. Miller <davem@davemloft.net>
I've added David S.Miller for few of the patches, i will cc him for
all the patches.
>
> to Cc list, as he is also listed as crypto maintainer in MAINTAINERS file.
>
> Best regards,
> Tomasz
Sure, thanks Tomasz.



-- 
Shine bright,
(: Nav :)
