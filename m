Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaG1UDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:03:01 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:47555 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaG1UC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOf5uwk=ctww=pP4Ae+1C6i-oOtiYTv2NJbj1GpuPwVSKXB4Hw@mail.gmail.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com>
	<1406577213-9642-4-git-send-email-marek@goldelico.com>
	<CAOf5uwk=ctww=pP4Ae+1C6i-oOtiYTv2NJbj1GpuPwVSKXB4Hw@mail.gmail.com>
Date: Mon, 28 Jul 2014 22:02:50 +0200
Message-ID: <CAAfyv35jvhzvjCKMwrpa=RQ1JkfcmthCsGDzwLW9Y6bq3Ww_fg@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm: dts: Add gta04a5 model
From: Belisko Marek <marek.belisko@gmail.com>
To: Michael Trimarchi <michael@amarulasolutions.com>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Tony Lindgren <tony@atomide.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Jul 28, 2014 at 9:56 PM, Michael Trimarchi
<michael@amarulasolutions.com> wrote:
> Hi Marek
>
> Il 28/lug/2014 21:54 "Marek Belisko" <marek@goldelico.com> ha scritto:
>
>
>>
>> Add model a5 which have additional jack detection.
>>
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  arch/arm/boot/dts/Makefile          |  1 +
>>  arch/arm/boot/dts/omap3-gta04a5.dts | 17 +++++++++++++++++
>>  2 files changed, 18 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/omap3-gta04a5.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 7d45fde..576c595 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -285,6 +285,7 @@ dtb-$(CONFIG_ARCH_OMAP3) += am3517-craneboard.dtb \
>>         omap3-evm-37xx.dtb \
>>         omap3-gta04a3.dtb \
>>         omap3-gta04a4.dtb \
>> +       omap3-gta04a5.dtb \
>>         omap3-igep0020.dtb \
>>         omap3-igep0030.dtb \
>>         omap3-ldp.dtb \
>> diff --git a/arch/arm/boot/dts/omap3-gta04a5.dts
>> b/arch/arm/boot/dts/omap3-gta04a5.dts
>> new file mode 100644
>> index 0000000..210317c3
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/omap3-gta04a5.dts
>> @@ -0,0 +1,17 @@
>> +/*
>> + * Copyright (C) 2014 H. Nikolaus Schaller <hns@goldelico.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include "omap3-gta04.dtsi"
>> +
>> +/ {
>> +       model = "Goldelico GTA04A5;
>> +
>> +       sound {
>> +               ti,jack-det-gpio = <&twl_gpio 2 0>;    /* GTA04A5 only */
>> +       };
>> +};
>> --
>> 1.9.1
>>
>
> Can we have only one dts with status enabled/disabled?
Do you mean to define this node it gta04.dtsi disabled and enable only
for a5 model?
>
> Michael
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
