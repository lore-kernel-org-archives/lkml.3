Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaGHWFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:05:23 -0400
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:44003 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751082AbaGHWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:05:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2895:2933:293
X-HE-Tag: hill10_11287ff166b04
X-Filterd-Recvd-Size: 3014
Message-ID: <1404857116.932.68.camel@joe-AO725>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Date: Tue, 08 Jul 2014 15:05:16 -0700
In-Reply-To: <20140708215229.GA4603@linux.vnet.ibm.com>
References: <20140707224146.GA9118@linux.vnet.ibm.com>
	 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140708080908.GN19379@twins.programming.kicks-ass.net>
	 <1404842784.932.22.camel@joe-AO725>
	 <20140708204124.GW4603@linux.vnet.ibm.com>
	 <1404853264.932.52.camel@joe-AO725>
	 <20140708215229.GA4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 14:52 -0700, Paul E. McKenney wrote:
> On Tue, Jul 08, 2014 at 02:01:04PM -0700, Joe Perches wrote:
> > On Tue, 2014-07-08 at 13:41 -0700, Paul E. McKenney wrote:
[]
> > > scripts: Teach get_maintainer.pl about the new "R:" tag
> 
> [ . . . ]
> 
> > Paul, I already sent you a better version over a month ago.
> 
> That would explain why I had already forgotten about it.  ;-)
> 
> > https://lkml.org/lkml/2014/6/2/585

Too bad because you added your own "tested-by"
in a reply. :p

> Unless you tell me otherwise, I assume that this means that you are
> OK with my adding your Signed-off-by to that patch.  (The lack thereof
> being another reason I would not have queued it.)  Please see below for
> the proposed commit log and Signed-off-by.
> 
> If you don't tell me otherwise, I will submit this to the next merge
> window.

Swell.

I still think the concept is pretty useless and it's
just a duplication of "M:", which isn't anything other
than a list of who should be sent patches.

MAINTAINERS describes the "M:" letter as just:

	M: Mail patches to: FullName <address@domain>

It doesn't describe anything like a pull hierarchy
or even describe actual maintainership.

But if "R:" is going to go in, then get_maintainers
should be updated at the same time.

btw: most "M:" entries aren't actual maintainers.

Maybe those non-maintainer "M:" entries should be
converted to the "R:" category and "M:" should
only be used to describe for the pull hierarchy.


