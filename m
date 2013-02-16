Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3BPMk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 07:40:29 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:35963 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3BPMk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 07:40:28 -0500
MIME-Version: 1.0
In-Reply-To: <20130216122403.GA2445@localhost>
References: <1361014708-1659-1-git-send-email-anilk4.v@gmail.com>
	<1361014708-1659-2-git-send-email-anilk4.v@gmail.com>
	<20130216122403.GA2445@localhost>
Date: Sat, 16 Feb 2013 18:10:25 +0530
Message-ID: <CABYxbz5nSY3TyTkH-_i0avv2v8nCWB_Vyn7uRNLkBmpk4W04DA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: omap3: Add gpmc node
From: Anil Kumar <anilk4.v@gmail.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, b-cousson@ti.com,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, zonque@gmail.com,
        thomas@tomweber.eu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 16, 2013 at 5:54 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Hi Anil,
>
> On Sat, Feb 16, 2013 at 05:08:27PM +0530, Anil Kumar wrote:
>> Add gpmc DT node.
>>
>> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
>> ---
>> :100644 100644 1acc261... 9f36531... M        arch/arm/boot/dts/omap3.dtsi
>>  arch/arm/boot/dts/omap3.dtsi |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>> index 1acc261..9f36531 100644
>> --- a/arch/arm/boot/dts/omap3.dtsi
>> +++ b/arch/arm/boot/dts/omap3.dtsi
>> @@ -397,5 +397,16 @@
>>                       ti,timer-alwon;
>>                       ti,timer-secure;
>>               };
>> +
>> +             gpmc: gpmc@6e000000 {
>> +                     compatible = "ti,omap3430-gpmc";
>> +                     ti,hwmods = "gpmc";
>> +                     reg = <0x6e000000 0x1000000>;
>> +                     interrupts = <20>;
>> +                     gpmc,num-cs = <8>;
>> +                     gpmc,num-waitpins = <4>;
>> +                     #address-cells = <2>;
>> +                     #size-cells = <1>;
>> +             };
>>       };
>>  };
>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> This patch has been already sent twice to the mailing list.
> Perhaps it would be more polite if you could base your work on
> one of those instead of sending it yourself again.
>
> Florian Vaussard sent one on January 28th:
> [PATCH 1/2] ARM: dts: OMAP3: Add GPMC controller

ok, I missed this patch. I will re base my changes on of this patch.

>
> Javier Martinez Canillas sent another one on February 09th:
> [PATCH RFC 6/7] ARM: dts: OMAP: Add an GPMC node for OMAP3
>
> Moreover, you could help to get patches merged faster by sending
> your Acked-by or Tested-by.
>

Sure i do that.

Thanks,
Anil
