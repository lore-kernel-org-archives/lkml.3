Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3FJWK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:10:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4500 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab3FJWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:10:58 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eB9Tj_0eLcoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=XIlBwW5Cg4gA:10 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=IjJRYWstNwOpoeDe-NIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370902256.9844.131.camel@gandalf.local.home>
Subject: Re: Another RCU trace. (3.10-rc5)
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>
Date: Mon, 10 Jun 2013 18:10:56 -0400
In-Reply-To: <20130610215421.GA31251@redhat.com>
References: <20130610195145.GA26068@redhat.com>
	 <20130610203355.GO5146@linux.vnet.ibm.com>
	 <20130610210123.GA27154@redhat.com>
	 <20130610211803.GR5146@linux.vnet.ibm.com>
	 <1370900256.9844.128.camel@gandalf.local.home>
	 <20130610215421.GA31251@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 17:54 -0400, Dave Jones wrote:
> On Mon, Jun 10, 2013 at 05:37:36PM -0400, Steven Rostedt wrote:
>  > On Mon, 2013-06-10 at 14:18 -0700, Paul E. McKenney wrote:
>  > > On Mon, Jun 10, 2013 at 05:01:23PM -0400, Dave Jones wrote:
>  > > > On Mon, Jun 10, 2013 at 01:33:55PM -0700, Paul E. McKenney wrote:
>  > > > 
>  > > >  > > I saw some of Steven's patches get merged on Friday, is there anything else
>  > > >  > > outstanding that didn't make it in yet that I could test ?
>  > > >  > > Or is this another new bug ?
>  > > >  > 
>  > > >  > I have three fixes queued up at:
>  > > >  > 
>  > > >  > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
>  > > >  > 
>  > > >  > Kind of hard to tell whether they are relevant given the interleaved
>  > > >  > stack traces, but can't hurt to try them out.
>  > > > 
>  > > > Here's another. Looks different.
>  > > 
>  > > I bet that commit d6284099 (trace: Allow idle-safe tracepoints to be
>  > > called from irq) from the above git archive fixes this one.  Just don't
>  > > ask how much I am willing to bet.  ;-)
>  > 
>  > Don't bet much ;-)  This has nothing to do with tracepoints. It's due to
>  > the function tracer. 
> 
> dammit, 20 minutes after I finally cloned the repo.
> Can we go back to posting diffs instead of hashes please ?
> 
> So while updating my list of bugs I've found this cycle, I noticed
> I'd already posted this one a month ago on -rc2.
> https://lkml.org/lkml/2013/5/21/327
> which led us to this patch https://lkml.org/lkml/2013/5/24/379
> After which I hit a bunch of what seem to be other RCU related bugs.
> 
> So maybe that patch was a winner after all and got dropped ?

I don't think it got dropped, it just seemed that it would go through
Peter:

https://lkml.org/lkml/2013/6/6/456

-- Steve

> 
> 	Dave
>  


