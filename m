Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3LSRuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:50:50 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30287 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LSRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:50:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18R0NE0O90jWOD0AMEzXdEi6eBx97vppCE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 69ECD4F7462
Date: Thu, 19 Dec 2013 12:50:17 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        rtc-linux@googlegroups.com, Pawel Moll <pawel.moll@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131219175017.GW2609@titan.lakedaemon.net>
References: <87siton6ke.fsf@natisbad.org>
 <20131219164624.GV2609@titan.lakedaemon.net>
 <87sitoka39.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sitoka39.fsf@natisbad.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:46:18PM +0100, Arnaud Ebalard wrote:
> Jason Cooper <jason@lakedaemon.net> writes:
> > On Thu, Dec 19, 2013 at 05:34:09PM +0100, Arnaud Ebalard wrote:
...
> >> I wonder if someone (Andrew? Stephen? Jason?) would be kind enough to
> >> take care of the v6 I just sent [1].
> >
> > I don't mind routing it though mvebu/arm-soc since the only consumers
> > are currently mvebu boards, but I'd like to hear from Andrew that this
> > is ok.
> 
> I will do what you think is the best.

It sounds like once you address Alessandro's concerns about /proc
entries, we should be able to take v7 through mvebu/arm-soc.

thx,

Jason.
