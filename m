Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaFBXTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:19:54 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:43463 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbaFBXTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:19:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtV1ALsFjVN5LL1sPGdsb2JhbABZgwdSgnOoFwEBAQEBAQaYGwGBDxcDAQEBATg1giUBAQU6HCMQCAMYCSUPBSUDBxoTiEHQOBaFP4gsAQFPB4RABJl/lngrgTk
Date: Tue, 3 Jun 2014 09:19:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Joe Perches <joe@perches.com>
Cc: josh@joshtriplett.org, Steven Rostedt <rostedt@goodmis.org>,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602231949.GV14410@dastard>
References: <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <1401734669.7323.20.camel@joe-AO725>
 <20140602145020.400d4e0c@gandalf.local.home>
 <20140602185504.GA13569@cloud>
 <1401735917.7323.23.camel@joe-AO725>
 <20140602190951.GA13648@cloud>
 <1401736666.7323.25.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401736666.7323.25.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:17:46PM -0700, Joe Perches wrote:
> On Mon, 2014-06-02 at 12:09 -0700, josh@joshtriplett.org wrote:
> > On Mon, Jun 02, 2014 at 12:05:17PM -0700, Joe Perches wrote:
> > > On Mon, 2014-06-02 at 11:55 -0700, josh@joshtriplett.org wrote:
> > > > this should go along with a change to
> > > > get_maintainer.pl to add those folks to the CC list.
> > > 
> > > Something like this:
> > 
> > Yes, exactly.  Given an appropriate commit message,
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> That's the sort of patch where reviewing is
> pretty useless.
> 
> What it needs is testing, not reviewing.
> 
> I tested it for all of 10 seconds.

>From Documentation/SubmittingPatches:

"         (c) While there may be things that could be improved with this
             submission, I believe that it is, at this time, (1) a
             worthwhile modification to the kernel, and (2) free of known
             issues which would argue against its inclusion.
.....

A Reviewed-by tag is a statement of opinion that the patch is an
appropriate modification of the kernel without any remaining serious
technical issues."

So, for someone to say they have reviewed the code and are able to
say it is free of known issues and has no remaining technical
issues, they would have had to apply, compile and test the patch,
yes?

i.e. Reviewed-by implies both Acked-by, Tested-by and that the code
is technically sound.

Anyone using Reviewed-by without having actually applied and tested
the patch is mis-using the tag - they should be using Acked-by: if
all they have done is read the code in their mail program....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
