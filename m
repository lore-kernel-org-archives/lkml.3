Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3LSTxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:53:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22333 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3LSTxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:53:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX193Z3dELCGOZWA/pWi9WY1w9jTFeW6RmG4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 102144F76EB
Date: Thu, 19 Dec 2013 14:52:32 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnaud Ebalard <arno@natisbad.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, rtc-linux@googlegroups.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131219195232.GZ2609@titan.lakedaemon.net>
References: <87siton6ke.fsf@natisbad.org>
 <20131219173857.0a546b99@linux.lan.towertech.it>
 <87d2kslphr.fsf@natisbad.org>
 <20131219184024.2a649328@linux.lan.towertech.it>
 <8761qkk96q.fsf@natisbad.org>
 <20131219180940.GY2609@titan.lakedaemon.net>
 <20131219194837.GA27311@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219194837.GA27311@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:48:37AM -0800, Guenter Roeck wrote:
> On Thu, Dec 19, 2013 at 01:09:40PM -0500, Jason Cooper wrote:
> > On Thu, Dec 19, 2013 at 07:05:49PM +0100, Arnaud Ebalard wrote:
> > > Hi,
> > > 
> > > Alessandro Zummo <a.zummo@towertech.it> writes:
> > > 
> > > >> Do you want me to send a v7 w/ the .proc helper removed or leave
> > > >> things as they are and Ack the patch as is?
> > > >
> > > >  Unless absolutely needed, I'd prefer if you can remove them
> > > >  or move to sysfs.
> > > 
> > > Well, my helper provides info on control and status registers flags
> > > (just like rtc-isl1208.c does), which are useful mainly for debug I
> > > guess. If this can help pushing things forward, I will send a v7 later
> > > today w/ the .proc helper removed from the patch.
> > 
> > Why not convert to debugfs?
> > 
> Separate follow-on patch, maybe, to keep things going ?

Sure.

thx,

Jason.
