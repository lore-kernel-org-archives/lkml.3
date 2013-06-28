Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3F1QUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:20:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3F1QUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:20:12 -0400
Date: Fri, 28 Jun 2013 12:19:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv6 0/5] xen: maintain an accurate persistent clock in more
 cases
Message-ID: <20130628161954.GB2452@phenom.dumpdata.com>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
 <alpine.DEB.2.02.1306281510180.4013@ionos.tec.linutronix.de>
 <20130628150158.GA5035@phenom.dumpdata.com>
 <alpine.DEB.2.02.1306281711310.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306281711310.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 05:12:35PM +0200, Thomas Gleixner wrote:
> On Fri, 28 Jun 2013, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jun 28, 2013 at 03:14:42PM +0200, Thomas Gleixner wrote:
> > > On Thu, 27 Jun 2013, David Vrabel wrote:
> > > > These series fixes the above limitations and depends on "x86: increase
> > > > precision of x86_platform.get/set_wallclock()" which was previously
> > > > posted.
> > > 
> > > So I'd like to merge that in the following way:
> > > 
> > > I pick up patches 1-3 and stick them into tip timers/for-xen and merge
> > > that branch into timers/core. When picking up 1/6, I'll drop the xen
> > > part of that, so timers/core will not hold any xen specific bits.
> > > 
> > > Then the xen folks can pull timers/for-xen and apply the xen specific
> > > stuff on top.
> > 
> > Wouldn't it be easier for you to pick the "xen part of that" as well?
> > I am OK with you doing that and it all going through your tree.
> 
> I can do that, if that's not conflicting with other xen/x86 stuff
> outside of timers/core.

I got one change in there and it seems to apply cleanly (woot!).
But lets be on a safe side. There are also some Xen ARM changes that
are fiddling with arch/x86/xen/time.c (different maintainer)) - so both
me and Stefano can pull from the timers/for-xen and not have to worry about
conflict resolution.

Thanks!
> 
> Thanks,
> 
> 	tglx
> 
