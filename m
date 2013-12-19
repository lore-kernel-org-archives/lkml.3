Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3LSWSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:18:43 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:51459 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab3LSWSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:18:41 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>, jason@lakedaemon.net,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [rtc-linux] Re: Can someone Ack and queue a patch for RTC subsytem?
References: <87siton6ke.fsf@natisbad.org>
	<20131219164624.GV2609@titan.lakedaemon.net>
	<20131219175738.1dad3ade@linux.lan.towertech.it>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131219:linux-kernel@vger.kernel.org::u3bhfUvEU/EInOio:0000000000000000000000000000000000FjZ
X-Hashcash: 1:20:131219:ijc+devicetree@hellion.org.uk::YVo3HjvJ/HCMxLpx:0000000000000000000000000000000000dc
X-Hashcash: 1:20:131219:treding@nvidia.com::hY67wSKN4iRpqvYC:00000000000000000000000000000000000000000000TTo
X-Hashcash: 1:20:131219:broonie@kernel.org::5XfdJwTsHdvxEAg4:00000000000000000000000000000000000000000000VpH
X-Hashcash: 1:20:131219:a.zummo@towertech.it::wqQSv7s12dhft5z7:000000000000000000000000000000000000000001EY3
X-Hashcash: 1:20:131219:mark.rutland@arm.com::ieiY5zoWZqAzeE0Z:0000000000000000000000000000000000000000018hZ
X-Hashcash: 1:20:131219:akpm@linux-foundation.org::c+WiY1OwliO/z+0G:0000000000000000000000000000000000001D0d
X-Hashcash: 1:20:131219:pawel.moll@arm.com::15fJiFUjD72czEKQ:00000000000000000000000000000000000000000001H85
X-Hashcash: 1:20:131219:sfr@canb.auug.org.au::kzfbemUkasIluoJE:000000000000000000000000000000000000000001oSA
X-Hashcash: 1:20:131219:galak@codeaurora.org::oGJY64JfwNtsosVj:000000000000000000000000000000000000000001t5k
X-Hashcash: 1:20:131219:rob@landley.net::mGMCFuizGnsQ8dMl:002AZH
X-Hashcash: 1:20:131219:linux-arm-kernel@lists.infradead.org::o9pSFz81aSwThDKA:00000000000000000000000003TOD
X-Hashcash: 1:20:131219:jason@lakedaemon.net::W3EgON4BYwlJbj1i:000000000000000000000000000000000000000003gQd
X-Hashcash: 1:20:131219:swarren@wwwdotorg.org::DEJxQbZ/Lu0UadiQ:00000000000000000000000000000000000000003H99
X-Hashcash: 1:20:131219:rtc-linux@googlegroups.com::Ml5XoCr0mZNyACaA:0000000000000000000000000000000000031Ak
X-Hashcash: 1:20:131219:grant.likely@linaro.org::JRdnvyLnsb4Gu+kM:0000000000000000000000000000000000000058ON
X-Hashcash: 1:20:131219:linux@roeck-us.net::ae/YYOubV2wmbk4q:00000000000000000000000000000000000000000003qTR
X-Hashcash: 1:20:131219:rob.herring@calxeda.com::v2Nk7RPuLhW/2/BQ:0000000000000000000000000000000000000070M+
X-Hashcash: 1:20:131219:peter.huewe@infineon.com::TEjTtho3G2PsRzEL:00000000000000000000000000000000000008G77
X-Hashcash: 1:20:131219:jgunthorpe@obsidianresearch.com::R9kmZSKfAsnc4TXK:0000000000000000000000000000007uLh
X-Hashcash: 1:20:131219:linus.walleij@linaro.org::jcIlX2BUeVL74fh1:000000000000000000000000000000000000078hq
Date: Thu, 19 Dec 2013 23:17:44 +0100
In-Reply-To: <20131219175738.1dad3ade@linux.lan.towertech.it> (Alessandro
	Zummo's message of "Thu, 19 Dec 2013 17:57:38 +0100")
Message-ID: <8761qk32pj.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alessandro Zummo <a.zummo@towertech.it> writes:

> On Thu, 19 Dec 2013 11:46:24 -0500
> Jason Cooper <jason@lakedaemon.net> wrote:
>
>> In the long term, should we seek out a co-maintainer for drivers/rtc?
>> Can anyone get a hold of Alessandro to get his opinion on this?
>
>  I'd surely appreciate if someone can take some time to give
>  a look to the patches. Most of them go thru subsystem's tree and, as
>  far as I can see, I saw very relevant comments and fixes in all those
>  years.

While I am at it, I wonder if you can give me some directions on the
following to add back alarm support to the ISL12057 on the specific
hardware I have.

All NETGEAR ReadyNAS 102, 104 and 2120 have an ISL 12057 RTC chip which
is used as main RTC clock but can also provide alarm. But the alarm
interrupt line of the chip is *not* connected to the SoC. It is
connected to some power component and can be used to wake up the NAS
when it is completely off and the alarm rings.

To me this kind of setup seems logical but it does not seem to be
directly supported by current RTC logic:

 - first, I cannot test an interrupt handler implementation I had
   written as the SoC will never receive any interrupt. This limits
   my ability to provide one to the driver.
 - what can/should be done in my .dts file to indicate that the
   device does not have any IRQ line connected (and hence no interrupt
   handler) to the SoC but still supports an alarm.

As a side note, the implementation I had was a working one on my
hardware (i.e. was able to wake up the device at a given time) but I had
to remove alarm code to get a basic driver accepted upstream.

To be honest, I tried and understand what RTC subsystem expects from
documentation and code w/o success. Any help appreciated on that topic.

Cheers,

a+
