Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaB1WkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:40:05 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40797 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaB1WkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:40:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140228222501.GL13624@atomide.com>
References: <1390685343-11663-1-git-send-email-marek@goldelico.com>
	<1390685343-11663-6-git-send-email-marek@goldelico.com>
	<20140228222501.GL13624@atomide.com>
Date: Fri, 28 Feb 2014 23:40:00 +0100
Message-ID: <CAAfyv34Agdabr3eg1VS9mHmTtefHf3HQrS6CWF4D9jkp2fEqzA@mail.gmail.com>
Subject: Re: [PATCH 5/9] ARM: dts: omap3-gta04: Add basic sound support.
From: Belisko Marek <marek.belisko@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Benoit Cousson <bcousson@baylibre.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Fri, Feb 28, 2014 at 11:25 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Marek Belisko <marek@goldelico.com> [140125 13:31]:
>
> Hmm care to add descriptions and repost the remaining patches
> that I did not yet pick up for the fixes?
Sure I'll do.
>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>
> Hmm should this also have From: NeilBrown <neilb@suse.de>?
Maybe I did some changes and forgot add my Signed-off-by? I'll recheck.
>
> Also, while at it, maybe change your long time habit of adding
> a period to the end of the subject line? That is of course
> if you don't insist on having it, it's not usually used if
> you look at git log --pretty=oneline :)
Sure . Thanks for notice ;). It there possibility that missing patches
go to 3.15?
>
> Regards,
>
> Tony
>
>> ---
>>  arch/arm/boot/dts/omap3-gta04.dts | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
>> index 7e09410..a924a843 100644
>> --- a/arch/arm/boot/dts/omap3-gta04.dts
>> +++ b/arch/arm/boot/dts/omap3-gta04.dts
>> @@ -36,6 +36,14 @@
>>                       gpio-key,wakeup;
>>               };
>>       };
>> +
>> +     sound {
>> +             compatible = "ti,omap-twl4030";
>> +             ti,model = "gta04";
>> +
>> +             ti,mcbsp = <&mcbsp2>;
>> +             ti,codec = <&twl_audio>;
>> +     };
>>  };
>>
>>  &omap3_pmx_core {
>> @@ -79,6 +87,13 @@
>>               reg = <0x48>;
>>               interrupts = <7>; /* SYS_NIRQ cascaded to intc */
>>               interrupt-parent = <&intc>;
>> +
>> +             twl_audio: audio {
>> +                     compatible = "ti,twl4030-audio";
>> +                     codec {
>> +                     };
>> +             };
>> +
>>               vaux4: regulator-vaux4 {
>>                       compatible = "ti,twl4030-vaux4";
>>                       regulator-min-microvolt = <2800000>;
>> --
>> 1.8.3.2
>>

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
