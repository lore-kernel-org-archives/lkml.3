Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaFCVsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:48:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49272 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbaFCVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:48:16 -0400
Date: Tue, 3 Jun 2014 14:48:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603214809.GX22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1401809736-12023-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401822187.18833.24.camel@joe-AO725>
 <20140603201202.GW22231@linux.vnet.ibm.com>
 <1401826567.22133.2.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401826567.22133.2.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060321-9332-0000-0000-000000FC4B6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:16:07PM -0700, Joe Perches wrote:
> On Tue, 2014-06-03 at 13:12 -0700, Paul E. McKenney wrote:
> > On Tue, Jun 03, 2014 at 12:03:07PM -0700, Joe Perches wrote:
> > > On Tue, 2014-06-03 at 08:35 -0700, Paul E. McKenney wrote:
> > > > Paul Walmsley also noted the need for patch
> > > > submitters to know who the key reviewers are and suggested adding an
> > > > "R:" tag to the MAINTAINERS file to record this information on a
> > > > per-subsystem basis.
> > > []
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > []
> > > > @@ -70,6 +70,8 @@ Descriptions of section entries:
> > > >  
> > > >  	P: Person (obsolete)
> > > >  	M: Mail patches to: FullName <address@domain>
> > > > +	R: Designated reviewer, who should be CCed on patches,
> > > > +	   format: FullName <address@domain>
> > > >  	L: Mailing list that is relevant to this area
> > > >  	W: Web-page with status/info
> > > >  	Q: Patchwork web based patch tracking system site
> > > 
> > > Perhaps the M: and R: roles should be more fully
> > > described here.
> > > 
> > > The R: entry description doesn't need commas.
> > > 
> > > Maybe something like:
> > > 	M: Maintainer (to:) FullName <address@domain>
> > > 	R: Reviewer   (cc:) FullName <address@domain>
> > 
> > This is arguably better organized, but I need to keep my focus on adding
> > the designated reviewer.  I am not in a position to undertake a rewrite
> > of the MAINTAINER file preamble at this point.
> 
> That's silly, you're adding the "R" entry.
> Add a proper description for it.

I will take another look at R: in a few days and possibly wordsmith it.

> > > You might as well send the get_maintainer update with this
> > > series too.
> > 
> > Interesting...  Who is the maintainer for get_maintainer?  ;-)
> 
> Some numbskull just signed up for that.
> 
> He suggests you keep all the patches that add
> support for this "R: reviewer" feature together.

My reluctance is due to the fact that this will change how newbies
submit patches.  But if we get a few Acked-by or Reviewed-by responses
from high-level maintainers (Linus, Greg, Ingo, Thomas, Peter, Ted,
Dave, Ben, ...), I will of course be happy to queue it.

							Thanx, Paul

