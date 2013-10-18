Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3JRUZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:25:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41051 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3JRUZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <20131017140659.GF24056@e106331-lin.cambridge.arm.com>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
	<1381960030-1640-6-git-send-email-tim.kryger@linaro.org>
	<20131017140659.GF24056@e106331-lin.cambridge.arm.com>
Date: Fri, 18 Oct 2013 13:25:12 -0700
Message-ID: <CAAYSxho6shrzABy+G-Q8djcVMjxE4nvcoHUkGBDgwU8X0A0zFQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 5/6] ARM: dts: Specify clocks for timer on bcm11351
From: Tim Kryger <tim.kryger@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Christian Daudt <bcm@fixthebug.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:06 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
>> index 193659c..39c1395 100644
>> --- a/arch/arm/boot/dts/bcm11351.dtsi
>> +++ b/arch/arm/boot/dts/bcm11351.dtsi
>> @@ -95,7 +95,7 @@
>>               compatible = "brcm,kona-timer";
>>               reg = <0x35006000 0x1000>;
>>               interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
>> -             clock-frequency = <32768>;
>> +             clocks = <&hub_timer_clk>;
>
> This should probably be after the code change that enables support for a
> clocks property.
>
> Thanks,
> Mark.

This is already the case.

The driver change is patch 4 and this dts change is patch 5 of the series.
