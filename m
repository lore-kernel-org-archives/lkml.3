Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3F1PMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:12:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:46734 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3F1PMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:12:38 -0400
Date: Fri, 28 Jun 2013 17:12:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv6 0/5] xen: maintain an accurate persistent clock in more
 cases
In-Reply-To: <20130628150158.GA5035@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1306281711310.4013@ionos.tec.linutronix.de>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306281510180.4013@ionos.tec.linutronix.de> <20130628150158.GA5035@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 28, 2013 at 03:14:42PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 Jun 2013, David Vrabel wrote:
> > > These series fixes the above limitations and depends on "x86: increase
> > > precision of x86_platform.get/set_wallclock()" which was previously
> > > posted.
> > 
> > So I'd like to merge that in the following way:
> > 
> > I pick up patches 1-3 and stick them into tip timers/for-xen and merge
> > that branch into timers/core. When picking up 1/6, I'll drop the xen
> > part of that, so timers/core will not hold any xen specific bits.
> > 
> > Then the xen folks can pull timers/for-xen and apply the xen specific
> > stuff on top.
> 
> Wouldn't it be easier for you to pick the "xen part of that" as well?
> I am OK with you doing that and it all going through your tree.

I can do that, if that's not conflicting with other xen/x86 stuff
outside of timers/core.

Thanks,

	tglx

