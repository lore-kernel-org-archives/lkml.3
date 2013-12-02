Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3LBOBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:01:45 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47940 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3LBOBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:01:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131202095253.GC12952@e106331-lin.cambridge.arm.com>
References: <1385892707-25063-1-git-send-email-kasimling@gmail.com> <20131202095253.GC12952@e106331-lin.cambridge.arm.com>
From: Alex Ling <kasimling@gmail.com>
Date: Mon, 2 Dec 2013 22:01:20 +0800
Message-ID: <CAHaF_kjuXZOkUXiK-E8mk1BmMvBPf-dUkha+nRnM3XhKOoSOJA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: dts: Add missing clock names for exynos4412
 dwmmc node
To: Mark Rutland <mark.rutland@arm.com>
Cc: "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 5:52 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Sun, Dec 01, 2013 at 10:11:47AM +0000, Alex Ling wrote:
>> This patch adds "biu" and "ciu" clock names for exynos4412 dwmmc
>> node. Without this patch, dwmmc host driver will skip enabling the
>> two clocks and it will break dwmmc host function on exynos4412.
>> Tested on FriendlyARM TINY4412 board.
>
> The patch description is a little off; this patch adds the clocks as
> well as the clock-names.
Well noted. I'll update the description later. Thanks!
>
> The patch itself looks fine to me.
>
> Mark.
>
>>
>> Signed-off-by: Alex Ling <kasimling@gmail.com>
>> ---
>>  arch/arm/boot/dts/exynos4412.dtsi |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
>> index e743e67..67bef99 100644
>> --- a/arch/arm/boot/dts/exynos4412.dtsi
>> +++ b/arch/arm/boot/dts/exynos4412.dtsi
>> @@ -67,5 +67,7 @@
>>               interrupts = <0 77 0>;
>>               #address-cells = <1>;
>>               #size-cells = <0>;
>> +             clocks = <&clock 301>, <&clock 149>;
>> +             clock-names = "biu", "ciu";
>>       };
>>  };
>> --
>> 1.7.9.5
>>
>>

BR,
Alex
