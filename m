Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaBGSI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:08:56 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21317 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBGSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:08:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/9uKyaJF/0Kv321SVECrWf0mrj31ZtZMo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 436755212A0
Date: Fri, 7 Feb 2014 13:08:36 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] irqchip: dove: drivers for v3.14
Message-ID: <20140207180836.GE8533@titan.lakedaemon.net>
References: <20131201172914.GV2879@titan.lakedaemon.net>
 <20131211175037.GY10053@titan.lakedaemon.net>
 <20140110183430.GO19878@titan.lakedaemon.net>
 <20140128173531.GT29184@titan.lakedaemon.net>
 <alpine.DEB.2.02.1402041959110.24986@ionos.tec.linutronix.de>
 <20140204211219.GK8533@titan.lakedaemon.net>
 <alpine.DEB.2.02.1402042230230.24986@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402042230230.24986@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:30:53PM +0100, Thomas Gleixner wrote:
> On Tue, 4 Feb 2014, Jason Cooper wrote:
> 
> > On Tue, Feb 04, 2014 at 07:59:58PM +0100, Thomas Gleixner wrote:
> > > On Tue, 28 Jan 2014, Jason Cooper wrote:
> > > > I see you pulled in mvebu/irqchip-fixes.  Thanks for that.  It's getting
> > > > near to the end of the merge window and there's been no activity on this
> > > > pull request.
> > > > 
> > > > Please let us know if there's anything we can do to assist.
> > > 
> > > Nah. I simply forgot about it. About to send a pull request to Linus.
> > 
> > hmmm.  I see the pull request contains the patches from
> > mvebu/irqchip-fixes (armada), but not the patches from mvebu/irqchip
> > (dove):
> > 
> >   40b367d95fb3 irqchip: irq-dove: Add PMU interrupt controller.
> > 
> > which is what this thread was originally a pull request for.
> > 
> > 
> > Are you planning to send a second pull request to Linus?
> 
> Duh. I'll pick that up tomorrow

Ping?

thx,

Jason.
