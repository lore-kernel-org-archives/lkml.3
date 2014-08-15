Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaHOPFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:05:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47260 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaHOPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:05:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vBILHRvOjn04NwVnq8m48C9NVM26yFM8=
X-DKIM: OpenDKIM Filter v2.0.1 titan BC3795C6650
Date: Fri, 15 Aug 2014 11:05:03 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: move of AIC drivers for 3.17: fixes #1
Message-ID: <20140815150503.GG5063@titan.lakedaemon.net>
References: <1408031156-13573-1-git-send-email-nicolas.ferre@atmel.com>
 <20140815142225.GF5063@titan.lakedaemon.net>
 <20140815164150.5085b324@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815164150.5085b324@bbrezillon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 04:41:50PM +0200, Boris BREZILLON wrote:
> On Fri, 15 Aug 2014 10:22:25 -0400 Jason Cooper <jason@lakedaemon.net> wrote:
> > On Thu, Aug 14, 2014 at 05:45:56PM +0200, Nicolas Ferre wrote:
> > > Arnd, Olof, Kevin,
> > > 
> > > Boris moved both of our AIC drivers to their new home: the drivers/irqchip
> > > directory taking advantage of the genirc framework. For DT-enabled SoCs, we can
> > > use these drivers (aic and aic5) right now: Jason merged them and they are
> > > available in early 3.17 merge window.
> > > So, I build this pull-request for enabling the use of these drivers now as:
> > > - we are very early in 3.17 development
> > > - it allowed us to avoid having to depend on Jason's branch before the opening
> > >   of the merge window
> > 
> > Then why did I create a topic branch for you to base on?
> > 
> >   git://git.infradead.org/users/jcooper/linux.git irqchip/atmel-aic
> 
> Don't blame Nicolas for this, he was in vacation when you created this
> branch (he came back this week), and I should have told you that he
> couldn't use it for this release cycle.

'Blame' is too strong a word. :)  It was more of a friendly, "wtf?"  I
guess I could have worded it better...

> > > - it removes some code from the mach-at91 directory: including the whole
> > >   aic5 driver
> > > - we'd have quite a bit of time to solve issues if we found a bug
> > > - the code is basically moved so it should be error free.
> > 
> > Well, this is certainly up to Arnd, Olof and Kevin, but it seems a bit
> > unusual.  You're basically asking to merge changes into the current window
> > that has had _no_ time in -next...  Sounds like a recipe for trouble to
> > me.
> > 
> > In the future, please let me know if you're not going to need a topic
> > branch.
> 
> This is all my fault, I'm the one who asked Nicolas to get these patches
> merged in 3.17, and, as I said, I should have told you that he was in
> vacation and thus could not use your topic branch for this release
> cycle.

Ah, no problem.  If there was nothing exciting going on in the SoC
directory, I probably could have kept the whole series together in one
branch with just an Ack.  But that's water under the bridge now.

We'll see what arm-soc says, but I suspect it's going to be wait for the
next window...

thx,

Jason.
