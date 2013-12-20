Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3LTBBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:01:31 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39312 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LTBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:01:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QTxxZMorDLb5V4SQO8ga2ylqjKZZszzk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5EE804F79E3
Date: Thu, 19 Dec 2013 19:57:58 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, rtc-linux@googlegroups.com,
        Pawel Moll <pawel.moll@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131220005758.GA2609@titan.lakedaemon.net>
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
> Hi,
> 
> Jason Cooper <jason@lakedaemon.net> writes:
> 
> > On Thu, Dec 19, 2013 at 05:34:09PM +0100, Arnaud Ebalard wrote:
> >> I have a very simple driver (support for reading and setting the time)
> >> for a RTC chip (Intersil ISL 12057) but cannot find anyone to get it
> >> Acked and queued for v3.14. In v3.14, there should be at least three
> >> users of the driver (ReadyNAS 102, 104 and 2120) if I meet -rc5 cutoff
> >> for associated .dts changes.
> >
> > The -rc5 cutoff isn't a hard line.  It's also mvebu-specific.  eg, We
> > need things _posted_ a week or so before arm-soc's cutoff of -rc6 so we
> > have time to get the pull request in.  If it needs to go through
> > mvebu/arm-soc, once it's posted, you're good.
> 
> I understand. But I guess you will not (for valid reason) accept .dts
> changes to reference a rtc driver that is not on good track towards
> -next. This is the issue I try and solve.

Just a subtle note here.  If the binding is stabilized, I don't mind
taking the dts changes.  However, if we have time, I prefer to wait for
the whole series to be hashed out.  You never know which resolutions
will end up revisiting the bindings you thought were good. :)

So, it's technically not a requirement for the whole driver to be
settled, but it is a good idea.

thx,

Jason.
