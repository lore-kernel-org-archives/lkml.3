Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3BETIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:08:10 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36386 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab3BETIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:08:06 -0500
Date: Tue, 5 Feb 2013 06:11:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        rostedt@goodmis.org, rbraun@sceen.net, zhong@linux.vnet.ibm.com,
        markus@trippelsdorf.de, sasha.levin@oracle.com,
        cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.9
Message-ID: <20130205141124.GA12785@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130204171817.GA18332@linux.vnet.ibm.com>
 <20130204180734.GA10022@gmail.com>
 <20130204193041.GA16853@gmail.com>
 <20130204202523.GZ2632@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204202523.GZ2632@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020519-7606-0000-0000-0000081A0D53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 12:25:23PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 04, 2013 at 08:30:41PM +0100, Ingo Molnar wrote:
> > 
> > Btw., I'm now getting these build errors in -tip too:
> > 
> >  kernel/built-in.o: In function `rcu_torture_reader':
> >  rcutorture.c:(.text+0x657d7): undefined reference to `trace_clock_local'
> >  kernel/built-in.o: In function `rcu_torture_timer':
> >  rcutorture.c:(.text+0x6599f): undefined reference to `trace_clock_local'
> > 
> > Saw the discussion about so I suspect a fix will come?
> 
> <red face>
> 
> I have a new rcu/next with the fix, and I will post a pull for it assuming
> that -next does OK with it.

And this change is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next

Steven Rostedt (1):
      rcu: Allow rcutorture to be built at low optimization levels

 kernel/rcutorture.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

 							Thanx, Paul

