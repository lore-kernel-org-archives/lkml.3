Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3CUKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:16:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41175 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab3CUKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:16:56 -0400
Date: Thu, 21 Mar 2013 11:16:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321101650.GA11214@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
	josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
	geoff@infradead.org, tglx@linutronix.de,
	Arjan van de Ven <arjan@linux.intel.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <1363825631.6345.45.camel@gandalf.local.home>
 <20130321022259.GM3637@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130321022259.GM3637@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 07:22:59PM -0700, Paul E. McKenney wrote:
> > > > > The "full_nohz=" boot parameter specifies which CPUs are to be
> > > > > adaptive-ticks CPUs.  For example, "full_nohz=1,6-8" says that CPUs 1,
> > > > 
> > > > This is the first time you mention "adaptive-ticks". Probably should
> > > > define it before just using it, even though one should be able to figure
> > > > out what adaptive-ticks are, it does throw in a wrench when reading this
> > > > if you have no idea what an "adaptive-tick" is.
> > > 
> > > Good point, changed the first sentence of this paragraph to read:
> > > 
> > > 	The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to
> > > 	avoid sending scheduling-clock interrupts to CPUs with a single
> > > 	runnable task, and such CPUs are said to be "adaptive-ticks CPUs".
> > 
> > Sounds good.

Yeah,

so I read this last night too and I have to say, very clearly written,
even for dummies like me.

But this "adaptive-ticks CPUs" reads kinda strange throughout the whole
text, it feels a bit weird. And since the cmdline option is called
"full_nohz", you might just as well call them the "full_nohz CPUs" or
the "full_nohz subset of CPUs" for simplicity and so that you don't have
yet another new term in the text denoting the same idea. I mean, all
those names kinda suck and need the full definition of what adaptive
ticking actually means anyway. :)

Btw, congrats on coining a new noun: "Adaptive-tick mode may prevent
this round-robining from happening."
     ^^^^^^^^^^^^^^

Funny. :-)

I spose now one can say: "The kids in the garden are round-robining on
the carousel."

or

"The kernel developers are round-robined for pull requests."

Or maybe it wasn't you who coined it after /me doing a little search. It
looks like technical people are pushing hard for it to be committed in
the upstream English language repository. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
