Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3LSQrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:47:03 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11909 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751097Ab3LSQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:47:00 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/1Gh6QqoS4juJas14z6ab656lpNpmZ1GI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6292B4F7316
Date: Thu, 19 Dec 2013 11:46:24 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Guenter Roeck <linux@roeck-us.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131219164624.GV2609@titan.lakedaemon.net>
References: <87siton6ke.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siton6ke.fsf@natisbad.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud,

On Thu, Dec 19, 2013 at 05:34:09PM +0100, Arnaud Ebalard wrote:
> I have a very simple driver (support for reading and setting the time)
> for a RTC chip (Intersil ISL 12057) but cannot find anyone to get it
> Acked and queued for v3.14. In v3.14, there should be at least three
> users of the driver (ReadyNAS 102, 104 and 2120) if I meet -rc5 cutoff
> for associated .dts changes.

The -rc5 cutoff isn't a hard line.  It's also mvebu-specific.  eg, We
need things _posted_ a week or so before arm-soc's cutoff of -rc6 so we
have time to get the pull request in.  If it needs to go through
mvebu/arm-soc, once it's posted, you're good.

The rtc driver shouldn't go through mvebu/arm-soc.  It should go through
the rtc maintainer's tree.

> I never heard of *listed* RTC maintainer during all the review process
> on rtc-linux list (v0 sent in october); I dug the list archives and when
> this previously happened, someone else (e.g. Andrew Morton) was kind
> enough to handle the patches:
> 
>   http://www.spinics.net/lists/arm-kernel/msg292187.html

Unfortunately, it doesn't look like Alessandro has been active for a
while and Andrew Morton has indeed been picking up the slack.  S-o-B's
confirm this.

I haven't worked with Andrew enough to know his workflow, but I imagine
he can take patches much closer to the merge window than we can.

> I wonder if someone (Andrew? Stephen? Jason?) would be kind enough to
> take care of the v6 I just sent [1].

I don't mind routing it though mvebu/arm-soc since the only consumers
are currently mvebu boards, but I'd like to hear from Andrew that this
is ok.

In the long term, should we seek out a co-maintainer for drivers/rtc?
Can anyone get a hold of Alessandro to get his opinion on this?

thx,

Jason.

> [1]: http://patchwork.ozlabs.org/patch/303616/
