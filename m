Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaFCBLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:11:30 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:47202 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbaFCBL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:11:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Asx1AI0fjVN5LL1sPGdsb2JhbABZgweDRagXAQEBAQEBBpgbAYEPFwMBAQEBODWCJQEBBAE6HCMFCwgDEgYJJQ8FJQMHBieIOgfQWRaFP4gsAQFPBxaEKgSZf5Z4K4E5
Date: Tue, 3 Jun 2014 11:11:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: josh@joshtriplett.org
Cc: Joe Perches <joe@perches.com>, Steven Rostedt <rostedt@goodmis.org>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603011125.GW14410@dastard>
References: <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <1401734669.7323.20.camel@joe-AO725>
 <20140602145020.400d4e0c@gandalf.local.home>
 <20140602185504.GA13569@cloud>
 <1401735917.7323.23.camel@joe-AO725>
 <20140602190951.GA13648@cloud>
 <1401736666.7323.25.camel@joe-AO725>
 <20140602231949.GV14410@dastard>
 <20140602235915.GB14801@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602235915.GB14801@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 04:59:15PM -0700, josh@joshtriplett.org wrote:
> On Tue, Jun 03, 2014 at 09:19:49AM +1000, Dave Chinner wrote:
> > On Mon, Jun 02, 2014 at 12:17:46PM -0700, Joe Perches wrote:
> > > What it needs is testing, not reviewing.
> > > 
> > > I tested it for all of 10 seconds.
> > 
> > From Documentation/SubmittingPatches:
> > 
> > "         (c) While there may be things that could be improved with this
> >              submission, I believe that it is, at this time, (1) a
> >              worthwhile modification to the kernel, and (2) free of known
> >              issues which would argue against its inclusion.
> > .....
> > 
> > A Reviewed-by tag is a statement of opinion that the patch is an
> > appropriate modification of the kernel without any remaining serious
> > technical issues."
> > 
> > So, for someone to say they have reviewed the code and are able to
> > say it is free of known issues and has no remaining technical
> > issues, they would have had to apply, compile and test the patch,
> > yes?
> > 
> > i.e. Reviewed-by implies both Acked-by, Tested-by and that the code
> > is technically sound.
> 
> No, not at all.  It implies Acked-by, and that the code is technically
> sound (both at the micro-level and in overall architecture/approach),
> but does not imply Tested-by; that's a separate tag for a reason.

You've ignored the (c).(2) "free of known issues" criteria there.
You cannot say a patch is free of issues if you haven't applied,
compiled and tested it.

> We should not, for instance, prevent someone from providing a
> Reviewed-by (as opposed to an Acked-by) for a driver whose hardware few
> people actually have.  There's significant value in code review even
> without the ability to test.

I don't disagree with you that there's value in code review, but
that's not the only part of what "reviewed-by" means.

You can test that the code is free of known issues without reviewing
it (i.e. tested-by). You can read the code and note that you can't
see any technical issues without testing it (Acked-by).

But you can't say that is it both free of techical and known
issues without both reading the code and testing it (Reviewed-by).

> > Anyone using Reviewed-by without having actually applied and tested
> > the patch is mis-using the tag - they should be using Acked-by: if
> > all they have done is read the code in their mail program....
> 
> Acked-by and Reviewed-by mean two different things (Reviewed-by being a
> superset of Acked-by), and the difference is not "I've applied and
> tested this"; that's Tested-by.

Right, the difference is more than that - Reviewed-by is a
superset of both Acked-by and Tested-by.

And, yes, this is the definition we've been using for "reviewed-by"
for XFS code since, well, years before the "reviewed-by" tag even
existed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
