Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3CUPSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:18:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50608 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab3CUPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:18:41 -0400
Date: Thu, 21 Mar 2013 08:18:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321151811.GR3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <1363825631.6345.45.camel@gandalf.local.home>
 <20130321022259.GM3637@linux.vnet.ibm.com>
 <20130321101650.GA11214@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321101650.GA11214@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032115-9360-0000-0000-0000116BB4A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:16:50AM +0100, Borislav Petkov wrote:
> On Wed, Mar 20, 2013 at 07:22:59PM -0700, Paul E. McKenney wrote:
> > > > > > The "full_nohz=" boot parameter specifies which CPUs are to be
> > > > > > adaptive-ticks CPUs.  For example, "full_nohz=1,6-8" says that CPUs 1,
> > > > > 
> > > > > This is the first time you mention "adaptive-ticks". Probably should
> > > > > define it before just using it, even though one should be able to figure
> > > > > out what adaptive-ticks are, it does throw in a wrench when reading this
> > > > > if you have no idea what an "adaptive-tick" is.
> > > > 
> > > > Good point, changed the first sentence of this paragraph to read:
> > > > 
> > > > 	The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to
> > > > 	avoid sending scheduling-clock interrupts to CPUs with a single
> > > > 	runnable task, and such CPUs are said to be "adaptive-ticks CPUs".
> > > 
> > > Sounds good.
> 
> Yeah,
> 
> so I read this last night too and I have to say, very clearly written,
> even for dummies like me.

Can't say that I think of you as a dummy, but glad you liked it!

> But this "adaptive-ticks CPUs" reads kinda strange throughout the whole
> text, it feels a bit weird. And since the cmdline option is called
> "full_nohz", you might just as well call them the "full_nohz CPUs" or
> the "full_nohz subset of CPUs" for simplicity and so that you don't have
> yet another new term in the text denoting the same idea. I mean, all
> those names kinda suck and need the full definition of what adaptive
> ticking actually means anyway. :)

I am happy with either "adaptive-ticks CPUs" or "full_nohz CPUs", and
leave the choice to Frederic.

> Btw, congrats on coining a new noun: "Adaptive-tick mode may prevent
> this round-robining from happening."
>      ^^^^^^^^^^^^^^

Actually, this is a generic transformation.  Given an English verb,
you almost always add "ing" to create a noun.  Since "round-robin" is
used as a verb, as in "The scheduler will round-robin between the two
SCHED_RR tasks", "round-robining" may be used as a noun denoting the
action corresponding to the verb "round-robin".  There is no doubt
an argument as to whether this should be spelled "round-robining" or
"round-robinning", but I will leave this to those who care enough to
argue about it.  ;-)

> Funny. :-)
> 
> I spose now one can say: "The kids in the garden are round-robining on
> the carousel."
> 
> or
> 
> "The kernel developers are round-robined for pull requests."

;-)

> Or maybe it wasn't you who coined it after /me doing a little search. It
> looks like technical people are pushing hard for it to be committed in
> the upstream English language repository. :-)

The thing about English is that it is an open-source language, and always
has been.  English is defined by its usage, and the wise dictionary-makers
try their best to keep up.  (The unwise ones attempt to stop the evolution
of the English language.)  Everything good and everything bad about
English stems from this property.  ;-)

							Thanx, Paul

