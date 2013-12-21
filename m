Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3LUOSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 09:18:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58627 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LUOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 09:18:05 -0500
Date: Sat, 21 Dec 2013 14:16:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnaud Ebalard <arno@natisbad.org>
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
Message-ID: <20131221141643.GC30815@sirena.org.uk>
References: <87siton6ke.fsf@natisbad.org>
 <20131219164624.GV2609@titan.lakedaemon.net>
 <20131219175738.1dad3ade@linux.lan.towertech.it>
 <8761qk32pj.fsf@natisbad.org>
 <20131220183050.GB31886@sirena.org.uk>
 <8738lnl19p.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738lnl19p.fsf@natisbad.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 217.42.81.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] Re: Can someone Ack and queue a patch for RTC
 subsytem?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 09:23:46PM +0100, Arnaud Ebalard wrote:

> I do not even know to which specific component the irq line of the chip
> is connected. You can take a look at [1] to see what's on the PCB; if
> you have an idea about which one could be a good candidate (TPS65251?),
> I can try and check with an ohmmeter which pin is connected to confirm
> your guess. Then, I could look at the datasheet (if any) to see if it
> can relay the interrupt to the SoC (if the component is supported by
> Linux kernel).

That's a PMIC which is what I'd expect if it's able to wake the device -
if it's anything like the other TI PMICs it ought to be able to act as
an interrupt controller.
