Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaGHW0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:26:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41065 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaGHW0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:26:04 -0400
Date: Tue, 8 Jul 2014 15:25:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Message-ID: <20140708222557.GF4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707224146.GA9118@linux.vnet.ibm.com>
 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708080908.GN19379@twins.programming.kicks-ass.net>
 <1404842784.932.22.camel@joe-AO725>
 <20140708204124.GW4603@linux.vnet.ibm.com>
 <1404853264.932.52.camel@joe-AO725>
 <20140708215229.GA4603@linux.vnet.ibm.com>
 <1404857116.932.68.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857116.932.68.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070822-6688-0000-0000-0000031F989C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 03:05:16PM -0700, Joe Perches wrote:
> On Tue, 2014-07-08 at 14:52 -0700, Paul E. McKenney wrote:
> > On Tue, Jul 08, 2014 at 02:01:04PM -0700, Joe Perches wrote:
> > > On Tue, 2014-07-08 at 13:41 -0700, Paul E. McKenney wrote:
> []
> > > > scripts: Teach get_maintainer.pl about the new "R:" tag
> > 
> > [ . . . ]
> > 
> > > Paul, I already sent you a better version over a month ago.
> > 
> > That would explain why I had already forgotten about it.  ;-)
> > 
> > > https://lkml.org/lkml/2014/6/2/585
> 
> Too bad because you added your own "tested-by"
> in a reply. :p

That was because I was for whatever reason thinking that Someone Else
was going to be queueing these.  As it stands, I have a Signed-off-by,
which in my case implies Tested-by.

> > Unless you tell me otherwise, I assume that this means that you are
> > OK with my adding your Signed-off-by to that patch.  (The lack thereof
> > being another reason I would not have queued it.)  Please see below for
> > the proposed commit log and Signed-off-by.
> > 
> > If you don't tell me otherwise, I will submit this to the next merge
> > window.
> 
> Swell.
> 
> I still think the concept is pretty useless and it's
> just a duplication of "M:", which isn't anything other
> than a list of who should be sent patches.
> 
> MAINTAINERS describes the "M:" letter as just:
> 
> 	M: Mail patches to: FullName <address@domain>
> 
> It doesn't describe anything like a pull hierarchy
> or even describe actual maintainership.
> 
> But if "R:" is going to go in, then get_maintainers
> should be updated at the same time.
> 
> btw: most "M:" entries aren't actual maintainers.
> 
> Maybe those non-maintainer "M:" entries should be
> converted to the "R:" category and "M:" should
> only be used to describe for the pull hierarchy.

It will be interesting to see how things go.  There did seem to be
some people who were comfortable being listed as RCU reviewers, but
not as RCU maintainers.  Perhaps the same thing happens elsewhere.

							Thanx, Paul

