Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaFBR3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:29:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:63643 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750780AbaFBR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:29:08 -0400
Date: Mon, 2 Jun 2014 13:29:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602132905.0bdbe49b@gandalf.local.home>
In-Reply-To: <1401729778.5770.20.camel@joe-AO725>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1401729778.5770.20.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014 10:22:58 -0700
Joe Perches <joe@perches.com> wrote:

> > Paul Walmsley also noted the need for patch
> > submitters to know who the key reviewers are and suggested adding an
> > "R:" tag to the MAINTAINERS file to record this information on a
> > per-subsystem basis.
> 
> I'm not sure of the value of this.
> 
> Why not just mark the actual reviewers as maintainers?
> 
> The lack of reviewers problem is entirely distinct from
> the proposed solution.
> 
> I believe active reviewers will generally subscribe to a
> subsystem specific mailing list.
> 
> Perhaps it'd be better to get a "linux-rcu@vger.kernel.org"
> mailing list going.

I don't think we need a linux-rcu mailing list. I much rather see the
patches on LKML.

If you have a person that regularly reviews a patch and wants to be
Cc'd on all of them, then why not add them to MAINTAINERS?

> 
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
> 

Or perhaps after L:

-- Steve
