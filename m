Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaFBRem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:34:42 -0400
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:60533 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751063AbaFBRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:34:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2731:2828:2892:3138:3139:3140:
X-HE-Tag: arch21_4539527ef3d0d
X-Filterd-Recvd-Size: 2615
Message-ID: <1401730474.5770.24.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 10:34:34 -0700
In-Reply-To: <20140602132905.0bdbe49b@gandalf.local.home>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725>
	 <20140602132905.0bdbe49b@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 13:29 -0400, Steven Rostedt wrote:
> On Mon, 02 Jun 2014 10:22:58 -0700 Joe Perches <joe@perches.com> wrote:
> > > Paul Walmsley also noted the need for patch
> > > submitters to know who the key reviewers are and suggested adding an
> > > "R:" tag to the MAINTAINERS file to record this information on a
> > > per-subsystem basis.
[]
> > Why not just mark the actual reviewers as maintainers?
[]
> If you have a person that regularly reviews a patch and wants to be
> Cc'd on all of them, then why not add them to MAINTAINERS?

So we agree on that.
 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > []
> > > @@ -73,6 +73,8 @@ Descriptions of section entries:
> > >  	L: Mailing list that is relevant to this area
> > >  	W: Web-page with status/info
> > >  	Q: Patchwork web based patch tracking system site
> > > +	R: Designated reviewer, who should be CCed on patches,
> > > +	   format: FullName <address@domain>
> > >  	T: SCM tree type and location.
> > >  	   Type is one of: git, hg, quilt, stgit, topgit
> > >  	S: Status, one of the following:
> > 
> > If this is actually done, I suggest putting this
> > "R" entry description immediately after the "M" entry.
[]
> Or perhaps after L:

Either would be fine as long as the order is the same
in the actual subsystem section entries that follow.


