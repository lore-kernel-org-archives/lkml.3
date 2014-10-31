Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbaJaOxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:53:43 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:62245 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbaJaOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <1414719439.5833.25.camel@mtksdaap41>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	<1413973797-17619-9-git-send-email-yingjoe.chen@mediatek.com>
	<CABuKBe+Ew6R2Kb90-gDHBQ4HuydfFxJdYmr+v9-KNC-b0K4Tkw@mail.gmail.com>
	<1413984696.19686.72.camel@mtksdaap41>
	<CABuKBeLJuaDnCYuvvS6csNzvbTeEdgEUdZ4tBQeVPuw37JK11Q@mail.gmail.com>
	<1414129026.14830.588.camel@mtksdaap41>
	<1414719439.5833.25.camel@mtksdaap41>
Date: Fri, 31 Oct 2014 15:53:39 +0100
Message-ID: <CABuKBeKFZQAHPR4xjCnM+nz67zE79rWPTHbc=m3VKcCX54Q8rQ@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] ARM: mediatek: Fix description for mediatek SoCs
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        huang eddie <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

2014-10-31 2:37 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> Hi Matthias,
>
> Is this series + this new 8/8 patch OK?
> Anything else that I should change?
>

I checked the patches on my mt8135 board and they work for me. So from
my site everything fine.

I added the patches to my tree [0] branches v3.19-next/soc and v3.19-next/dts
I made a small change to the commit message of patch 8 and I will try
to send the pull request asap.

Thanks,
Matthias

[0] https://github.com/mbgg/linux-mediatek

> Joe.C
>
> On Fri, 2014-10-24 at 13:37 +0800, Yingjoe Chen wrote:
>> From: "Joe.C" <yingjoe.chen@mediatek.com>
>>
>> We support more MediaTek SoCs now, update the description.
>>
>> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
>> ---
>>  arch/arm/mach-mediatek/Kconfig | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-mediatek/Kconfig
>> b/arch/arm/mach-mediatek/Kconfig
>> index 2c043a2..f73f588 100644
>> --- a/arch/arm/mach-mediatek/Kconfig
>> +++ b/arch/arm/mach-mediatek/Kconfig
>> @@ -1,6 +1,6 @@
>>  config ARCH_MEDIATEK
>> -     bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
>> +     bool "Mediatek MT65xx & MT81xx SoC" if ARCH_MULTI_V7
>>       select ARM_GIC
>>       select MTK_TIMER
>>       help
>> -       Support for Mediatek Cortex-A7 Quad-Core-SoC MT6589.
>> +       Support for Mediatek MT65xx & MT81xx SoCs
>
>
>



-- 
motzblog.wordpress.com
