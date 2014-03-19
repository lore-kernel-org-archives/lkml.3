Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbaCSJx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:53:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:60054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198AbaCSJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:53:27 -0400
Date: Wed, 19 Mar 2014 10:53:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH 2/4] hrtimer: export __hrtimer_start_range_ns
In-Reply-To: <20140319084710.GD27632@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1403191053220.18573@ionos.tec.linutronix.de>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com> <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com> <20140319084710.GD27632@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014, Peter Zijlstra wrote:

> On Tue, Mar 18, 2014 at 04:56:42PM +0800, Yan, Zheng wrote:
> > export __hrtimer_start_range_ns() to allow building perf Intel uncore
> > driver as module
> 
> Bah; you didn't cc the hrtimer maintainer.
> 
> Thomas, ack on this?

Yup.
 
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > ---
> >  kernel/hrtimer.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index 0909436..650bf38 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -1030,6 +1030,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
> >  
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
> >  
> >  /**
> >   * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
> > -- 
> > 1.8.5.3
> > 
> 
