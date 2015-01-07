Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbbAGQM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:12:58 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45070 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbbAGQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:12:57 -0500
Date: Wed, 7 Jan 2015 08:12:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce
 tricks
Message-ID: <20150107161246.GY5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
 <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
 <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3299127A@ORSMSX114.amr.corp.intel.com>
 <20150107121340.GB3984@pd.tnic>
 <CALCETrW9N8Dw7r3m=r4rec4GKo18arFgOBxA+WnnLdw+AVb1BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW9N8Dw7r3m=r4rec4GKo18arFgOBxA+WnnLdw+AVb1BQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010716-0013-0000-0000-000007B35CAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 07:51:26AM -0800, Andy Lutomirski wrote:
> On Wed, Jan 7, 2015 at 4:13 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Jan 06, 2015 at 06:00:08PM +0000, Luck, Tony wrote:
> >> That's fine with me.  Boris ... any comments?
> >
> > Same here:
> >
> > Acked-by: Borislav Petkov <bp@suse.de>
> >
> > I like negative diffstats:
> >
> >  include/asm/mce.h         |    1
> >  include/asm/thread_info.h |    4 -
> >  kernel/cpu/mcheck/mce.c   |  109 ++++++++++------------------------------------
> >  kernel/signal.c           |    6 --
> >  4 files changed, 26 insertions(+), 94 deletions(-)
> >
> > Procedural question: so this is going in, in the next merge window,
> > aimed at 3.20, right?
> 
> Yes, assuming that Ingo and Thomas agree.
> 
> When does Paul usually send the rcu pull request?  I can send these as
> a pull request or an emailed series after that happens.

I normally send it to -tip at about -rc5.  Which is coming right up,
isn't it?  Guess I had better get my tree organized.  ;-)

							Thanx, Paul

> --Andy
> 
> >
> > IMO that is a good plan as we have max time to deal with fallout, should
> > there be any.
> >
> > Thanks.
> >
> > --
> > Regards/Gruss,
> >     Boris.
> >
> > Sent from a fat crate under my desk. Formatting is fine.
> > --
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> 

