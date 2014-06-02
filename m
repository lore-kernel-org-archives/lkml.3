Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaFBRsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:48:46 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57840 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaFBRsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:48:45 -0400
Date: Mon, 2 Jun 2014 10:48:37 -0700
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602174837.GA13257@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401729778.5770.20.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401729778.5770.20.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
> On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> > A ksummit-discuss email thread looked at the difficulty recruiting
> > and retaining reviewers.
> 
> []
> 
> > Paul Walmsley also noted the need for patch
> > submitters to know who the key reviewers are and suggested adding an
> > "R:" tag to the MAINTAINERS file to record this information on a
> > per-subsystem basis.
> 
> I'm not sure of the value of this.
> 
> Why not just mark the actual reviewers as maintainers?

As discussed in the kernel summit discussion, being a regular patch
reviewer isn't the same thing as being *the* maintainer.

> The lack of reviewers problem is entirely distinct from
> the proposed solution.

Not arguing with that; this change alone won't produce more reviewers,
but it does provide a means of tracking regular reviewers.

> I believe active reviewers will generally subscribe to a
> subsystem specific mailing list.

Not every driver or subsystem is large enough to have its own mailing
list, and many would prefer to keep their discussion on LKML.  Also,
mailing lists introduce diffusion of responsibility.

> Perhaps it'd be better to get a "linux-rcu@vger.kernel.org"
> mailing list going.

Perhaps.

> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -73,6 +73,8 @@ Descriptions of section entries:
> >  	L: Mailing list that is relevant to this area
> >  	W: Web-page with status/info
> >  	Q: Patchwork web based patch tracking system site
> > +	R: Designated reviewer, who should be CCed on patches,
> > +	   format: FullName <address@domain>
> >  	T: SCM tree type and location.
> >  	   Type is one of: git, hg, quilt, stgit, topgit
> >  	S: Status, one of the following:
> 
> If this is actually done, I suggest putting this
> "R" entry description immediately after the "M" entry.

Yeah, it does seem like these entries are not quite alphabetized, so
putting this right after M makes sense.

- Josh Triplett
