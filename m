Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3LSSCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:02:13 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52340 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752816Ab3LSSCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:02:11 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+XfFXRFYx2Ng7NtIBFKdHUM3JzObgFIt8=
X-DKIM: OpenDKIM Filter v2.0.1 titan C26384F74A2
Date: Thu, 19 Dec 2013 13:01:36 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arnaud Ebalard <arno@natisbad.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20131219180136.GX2609@titan.lakedaemon.net>
References: <87siton6ke.fsf@natisbad.org>
 <20131219173857.0a546b99@linux.lan.towertech.it>
 <87d2kslphr.fsf@natisbad.org>
 <20131219184024.2a649328@linux.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219184024.2a649328@linux.lan.towertech.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:40:24PM +0100, Alessandro Zummo wrote:
> On Thu, 19 Dec 2013 18:28:16 +0100 arno@natisbad.org (Arnaud Ebalard) wrote:
> > At some point, Alessandro Zummo wrote:
...
> > > I do not maintain a separate tree due to most RTCs being specifit to a
> > > subsytem.   
> > 
> > I do not understand: the chip is generic, i.e. this is not a RTC chip
> > specific to a given SoC (like rtc-mv.c is for instance). Can you be
> > more specific?
> 
>  Yes, this chip is generic, but most aren't. Some of those who
>  are generic, are strictly connected to a particular system/board, 
>  and they end up in that system's tree. Most of the drivers
>  are pretty small.

That goes against the whole goal of the arm-soc devicetree conversion.
For the past several years, we've been moving drivers _out_ of arch/arm/
into the appropriate drivers/ area.  The goal of this was to unclutter
arch/arm/, and to more readily see and remove code duplication by
drivers.

thx,

Jason.
