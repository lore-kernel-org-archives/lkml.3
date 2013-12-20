Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3LTUYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 15:24:37 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:33685 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab3LTUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:24:35 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Mark Brown <broonie@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, jason@lakedaemon.net,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [rtc-linux] Re: Can someone Ack and queue a patch for RTC subsytem?
References: <87siton6ke.fsf@natisbad.org>
	<20131219164624.GV2609@titan.lakedaemon.net>
	<20131219175738.1dad3ade@linux.lan.towertech.it>
	<8761qk32pj.fsf@natisbad.org> <20131220183050.GB31886@sirena.org.uk>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131220:jason@lakedaemon.net::2gNUQKeXzP8iYLPr:000000000000000000000000000000000000000000FG1
X-Hashcash: 1:20:131220:a.zummo@towertech.it::S/IUSgB3CjtBDcBM:0000000000000000000000000000000000000000008Dx
X-Hashcash: 1:20:131220:broonie@kernel.org::YKa2rJOGsv9vtC3a:000000000000000000000000000000000000000000001lk
X-Hashcash: 1:20:131220:treding@nvidia.com::go77cDGKWTvk5mXH:00000000000000000000000000000000000000000000XOW
X-Hashcash: 1:20:131220:grant.likely@linaro.org::FZENvK81iYLRavCF:000000000000000000000000000000000000000j65
X-Hashcash: 1:20:131220:galak@codeaurora.org::B3THRUFHRthztNWB:000000000000000000000000000000000000000000qov
X-Hashcash: 1:20:131220:linus.walleij@linaro.org::7r+3QTPTNI5GZdYm:00000000000000000000000000000000000001ExA
X-Hashcash: 1:20:131220:linux-kernel@vger.kernel.org::VB0NoBpwraUq+CMy:0000000000000000000000000000000001yCa
X-Hashcash: 1:20:131220:linux-arm-kernel@lists.infradead.org::lo7CyLdnjtjnsu7a:00000000000000000000000001oVF
X-Hashcash: 1:20:131220:rtc-linux@googlegroups.com::HqwkjNuXb5oA7hnm:000000000000000000000000000000000002aTS
X-Hashcash: 1:20:131220:peter.huewe@infineon.com::fpgaqv1362bRbo4w:00000000000000000000000000000000000003XbY
X-Hashcash: 1:20:131220:sfr@canb.auug.org.au::fjpoYrQgWJlRSQhT:0000000000000000000000000000000000000000038ZM
X-Hashcash: 1:20:131220:mark.rutland@arm.com::1u999jX1vs5A6K4p:000000000000000000000000000000000000000004HyX
X-Hashcash: 1:20:131220:jgunthorpe@obsidianresearch.com::FK0NKBVvJ1kA0K/e:0000000000000000000000000000003wLO
X-Hashcash: 1:20:131220:ijc+devicetree@hellion.org.uk::KDOEaLDb8+WcMmHH:0000000000000000000000000000000065Kp
X-Hashcash: 1:20:131220:akpm@linux-foundation.org::GdSxlzmf3W9c8Tko:0000000000000000000000000000000000007Tnz
X-Hashcash: 1:20:131220:rob@landley.net::tUcY6kv75I5AJSqF:009D6c
X-Hashcash: 1:20:131220:pawel.moll@arm.com::JPWRxaxSMG72kKDe:0000000000000000000000000000000000000000000CKft
X-Hashcash: 1:20:131220:rob.herring@calxeda.com::ckt/yuRS7MwhXBHT:00000000000000000000000000000000000000CUrs
X-Hashcash: 1:20:131220:linux@roeck-us.net::0QwWZtvCNFI2jP1t:0000000000000000000000000000000000000000000GOaC
X-Hashcash: 1:20:131220:swarren@wwwdotorg.org::VMeMtGN8M99kigrz:0000000000000000000000000000000000000000KtT5
Date: Fri, 20 Dec 2013 21:23:46 +0100
In-Reply-To: <20131220183050.GB31886@sirena.org.uk> (Mark Brown's message of
	"Fri, 20 Dec 2013 18:30:50 +0000")
Message-ID: <8738lnl19p.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Brown <broonie@kernel.org> writes:

> On Thu, Dec 19, 2013 at 11:17:44PM +0100, Arnaud Ebalard wrote:
>
>> All NETGEAR ReadyNAS 102, 104 and 2120 have an ISL 12057 RTC chip which
>> is used as main RTC clock but can also provide alarm. But the alarm
>> interrupt line of the chip is *not* connected to the SoC. It is
>> connected to some power component and can be used to wake up the NAS
>> when it is completely off and the alarm rings.
>
> Can the PMIC or whatever function as an interrupt controller and report
> the interrupt on to the SoC?

I do not even know to which specific component the irq line of the chip
is connected. You can take a look at [1] to see what's on the PCB; if
you have an idea about which one could be a good candidate (TPS65251?),
I can try and check with an ohmmeter which pin is connected to confirm
your guess. Then, I could look at the datasheet (if any) to see if it
can relay the interrupt to the SoC (if the component is supported by
Linux kernel).

But, except if we can do what you propose, there are two problems at
hand:

 1) I cannot currently test the IRQ handler my changes would bring
 because it is not connected to the SoC on my platforms

 2) even if I find a solution for 1), noone ever provided any directions
 on what should be required to make some program like rtc-test.c happy on
 my platforms (alarm support but no interrupt from the RTC). e.g. some 
 refinements like the one introduced by c9f5c7e7a84f1b7 (rtc: rtc-spear:
 Provide flag for no support of UIE mode). I guess it should be fairly
 simple for someone w/ good knowledge of the RTC subsystem to tell what
 is needed. I do not have that knowledge and the documentation does not
 help.

Regarding 1), I am starting to wonder if the best way out would not be
for me to connect the interrupt line of the ISL12057 to one of the GPIO
line currently connected to the LCD on my RN104 (after having
disconnected the LCD) and change the function of the associated MPP on
the SoC to make it an interrupt line. Could that work w/o additional
hardware modification? What are my chances of killing the board?

But this is pointless if I do not get any clear directions about 2).

Cheers,

a+

[1]: http://natisbad.org/NAS2/index.html#hw
