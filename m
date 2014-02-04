Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbaBDVXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:23:50 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39498 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934702AbaBDVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18glovHY8OnqdHWEuRHmGglD19nQqBO9Iw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 09ED351D6B4
Date: Tue, 4 Feb 2014 16:12:19 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] irqchip: dove: drivers for v3.14
Message-ID: <20140204211219.GK8533@titan.lakedaemon.net>
References: <20131201172914.GV2879@titan.lakedaemon.net>
 <20131211175037.GY10053@titan.lakedaemon.net>
 <20140110183430.GO19878@titan.lakedaemon.net>
 <20140128173531.GT29184@titan.lakedaemon.net>
 <alpine.DEB.2.02.1402041959110.24986@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402041959110.24986@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 07:59:58PM +0100, Thomas Gleixner wrote:
> On Tue, 28 Jan 2014, Jason Cooper wrote:
> > I see you pulled in mvebu/irqchip-fixes.  Thanks for that.  It's getting
> > near to the end of the merge window and there's been no activity on this
> > pull request.
> > 
> > Please let us know if there's anything we can do to assist.
> 
> Nah. I simply forgot about it. About to send a pull request to Linus.

hmmm.  I see the pull request contains the patches from
mvebu/irqchip-fixes (armada), but not the patches from mvebu/irqchip
(dove):

  40b367d95fb3 irqchip: irq-dove: Add PMU interrupt controller.

which is what this thread was originally a pull request for.


Are you planning to send a second pull request to Linus?

thx,

Jason.
