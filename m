Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3BFLoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:44:21 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:41942 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3BFLoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:44:20 -0500
Date: Wed, 6 Feb 2013 12:44:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130206114415.GE8696@gmail.com>
References: <20130204171817.GA18332@linux.vnet.ibm.com>
 <20130204180734.GA10022@gmail.com>
 <20130204193041.GA16853@gmail.com>
 <20130204202523.GZ2632@linux.vnet.ibm.com>
 <20130205141124.GA12785@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205141124.GA12785@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Feb 04, 2013 at 12:25:23PM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 04, 2013 at 08:30:41PM +0100, Ingo Molnar wrote:
> > > 
> > > Btw., I'm now getting these build errors in -tip too:
> > > 
> > >  kernel/built-in.o: In function `rcu_torture_reader':
> > >  rcutorture.c:(.text+0x657d7): undefined reference to `trace_clock_local'
> > >  kernel/built-in.o: In function `rcu_torture_timer':
> > >  rcutorture.c:(.text+0x6599f): undefined reference to `trace_clock_local'
> > > 
> > > Saw the discussion about so I suspect a fix will come?
> > 
> > <red face>
> > 
> > I have a new rcu/next with the fix, and I will post a pull for it assuming
> > that -next does OK with it.
> 
> And this change is available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> Steven Rostedt (1):
>       rcu: Allow rcutorture to be built at low optimization levels
> 
>  kernel/rcutorture.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)

Cool, thanks guys!

	Ingo
