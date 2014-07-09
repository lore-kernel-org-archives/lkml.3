Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaGIRmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:42:38 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49221 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaGIRmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:42:37 -0400
Date: Wed, 9 Jul 2014 19:42:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Message-ID: <20140709174231.GC23881@localhost.localdomain>
References: <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708080908.GN19379@twins.programming.kicks-ass.net>
 <1404842784.932.22.camel@joe-AO725>
 <20140708204124.GW4603@linux.vnet.ibm.com>
 <1404853264.932.52.camel@joe-AO725>
 <20140708215229.GA4603@linux.vnet.ibm.com>
 <1404857116.932.68.camel@joe-AO725>
 <20140708222557.GF4603@linux.vnet.ibm.com>
 <1404878965.932.87.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404878965.932.87.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:09:25PM -0700, Joe Perches wrote:
> On Tue, 2014-07-08 at 15:25 -0700, Paul E. McKenney wrote:
> > On Tue, Jul 08, 2014 at 03:05:16PM -0700, Joe Perches wrote:
> []
> > > I still think the concept is pretty useless and it's
> > > just a duplication of "M:", which isn't anything other
> > > than a list of who should be sent patches.
> []
> > It will be interesting to see how things go.
> 
> Yes, it might work out fine and maybe might cause some
> other beneficial changes.
> 
> > There did seem to be
> > some people who were comfortable being listed as RCU reviewers, but
> > not as RCU maintainers.  Perhaps the same thing happens elsewhere.
> 
> Maybe so.
> 
> I wrote a script to find which maintainer addresses that
> haven't signed or authored a commit in the last 2 years.
> 
> I got ~250 entries.  That's about 1/4 of all maintainer
> email addresses.
> 
> Maybe a dozen of these are false positives though because
> some maintainers prefer to receive email at one address
> but ack from another.
> 
> These are all lowercase for better matching.

Aren't we all falling in the typical pessimism trap, evil of the century!
Why do we always want to consider the lack of activity from a maintainer as a bad symptom?

What if it were actually a positive sign resulting of a finished, completed, and perfect
clean bug-free subsystem?

Once we accept that, all we need is support from the MAINTAINERS file:

diff --git a/MAINTAINERS b/MAINTAINERS
index 970c4a0..5da75dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -76,6 +76,9 @@ Descriptions of section entries:
 	T: SCM tree type and location.
 	   Type is one of: git, hg, quilt, stgit, topgit
 	S: Status, one of the following:
+          Finished:	The code is finished. The maintainer has fixed all
+			the bugs and adressed all missing features. No further
+			patch is needed.
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
 	   Odd Fixes:	It has a maintainer but they don't have time to do
