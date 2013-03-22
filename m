Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3CVJ3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:29:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:35306 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3CVJ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:28:58 -0400
Date: Fri, 22 Mar 2013 10:28:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Ingo Molnar <mingo@elte.hu>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: PREEMPT_RT vs 'hrtimer: Prevent hrtimer_enqueue_reprogram
 race'
In-Reply-To: <1363923275.6345.93.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1303221028250.22263@ionos>
References: <1363914713.31336.191.camel@deadeye.wl.decadent.org.uk>  <1363919473.6345.88.camel@gandalf.local.home>  <1363922685.3728.21.camel@deadeye.wl.decadent.org.uk> <1363923275.6345.93.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Steven Rostedt wrote:

> On Fri, 2013-03-22 at 03:24 +0000, Ben Hutchings wrote:
> 
> > > Note, I posted a fix on Tuesday:
> > > 
> > > https://lkml.org/lkml/2013/3/19/369
> > 
> > Thanks.  I did search GMANE with some obvious terms but I think its
> > index is lagging.
> 
> It didn't help that my subject had no mention of -rt in it :-(
> 
> > I'm rebasing the rt patch series generated with
> > 'git format-patch v3.2.39..v3.2.39-rt59-rebase' on top of v3.2.41 (plus
> > Debian changes, which introduce some trivial textual conflicts).
> 
> Ah, OK, I do it the opposite way. As the stable rt git never rebases, I
> always merge the latest stable into my tree. I then create a rebased
> tree as well. When I do that, I'm sure I'll end up fixing the patches up
> pretty much the same as you have.

Looks correct. The fixup is pretty obvious.

Thanks,

	tglx
