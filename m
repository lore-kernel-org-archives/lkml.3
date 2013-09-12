Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3ILQXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:23:24 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46364 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3ILQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <1379000686.10076.76.camel@kazak.uk.xensource.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	<1378968687-8200-5-git-send-email-cinifr@gmail.com>
	<20130912145756.GD22013@e106331-lin.cambridge.arm.com>
	<1379000686.10076.76.camel@kazak.uk.xensource.com>
Date: Fri, 13 Sep 2013 00:23:21 +0800
Message-ID: <CAK3cCByUJG42D6w4e1tdnXY0TQ517yOjQxFZJEnsyS4d0bxZyQ@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 4/4] Add arch count timer node in dts
 for Allwinner A20(sunxi 7i).
From: cinifr <cinifr@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 23:44, Ian Campbell <ijc@hellion.org.uk> wrote:
> On Thu, 2013-09-12 at 15:57 +0100, Mark Rutland wrote:
>
>> > +                   interrupts = <1 13 0x308>,
>> > +                                <1 14 0x308>,
>> > +                                <1 11 0x308>,
>> > +                                <1 10 0x308>;
>> > +                   clock-frequency = <24000000>;
>>
>> If at all possible, your bootloader should set CNTFREQ, and
>> clock-frequency should only be used as a last resort when it's
>> impossible to get it to set CNTFREQ. It's not possible to set CNTFREQ
>> from the non-secure side, so guests (which might not be Linux, and might
>> not handle DT in the same way) may see a completely wrong frequency
>> value.
Yes, My bootloader dont set it, and I have to set it at  dtsi  fot
boot, I found <clock-frequency> is be set in dtsi file for ohters
cups.
