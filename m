Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaK0WaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:30:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:59073 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaK0WaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:30:17 -0500
Date: Thu, 27 Nov 2014 23:30:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zheng.z.yan@intel.com, peterz@infradead.org, eranian@google.com
Subject: Re: perf/x86/intel/uncore: Add Haswell-EP uncore support
In-Reply-To: <20141127194910.GO10824@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1411272320580.3961@nanos>
References: <20141013152950.11DE26610F1@gitolite.kernel.org> <20141125232050.GA9408@redhat.com> <20141126141422.GM10824@tassilo.jf.intel.com> <20141126152646.GA7984@redhat.com> <20141127194910.GO10824@tassilo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Andi Kleen wrote:
> >  > > I'm wondering if these should be just wrmsr's instead of wrmsrl's.
> >  > 
> >  > Can we just shut up coverity please?
> > 
> > I can manually dismiss them, I don't think the checker has the
> > information to determine this for itself.
> 
> I suspect my out of line MSR patchkit would fix the warning
> as a side effect, because there would be a function call
> inbetween and the function always gets full u64.
> 
> https://lkml.org/lkml/2014/10/10/376
> 
> So far it hasn't been reviewed. I'll keep reposting.

And if you do so, can you please add a proper 0/n cover letter which
explains the scope of the series. I'm tired of wading through N
patches to figure out whether this is something I should care of or
not.

Thanks,

	tglx
