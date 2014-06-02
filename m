Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaFBSQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:16:03 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:53585 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752289AbaFBSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:16:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:25
X-HE-Tag: hair63_8ae0f23667b1d
X-Filterd-Recvd-Size: 3333
Message-ID: <1401732953.7323.6.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Darren Hart <dvhart@linux.intel.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        oleg@redhat.com, sbw@mit.edu
Date: Mon, 02 Jun 2014 11:15:53 -0700
In-Reply-To: <CA+5PVA6iC6nNCp4XD3X-xvRLLVw91AQEVBHVMJmh87Mz7b1Drg@mail.gmail.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>
	 <1401731968.7323.4.camel@joe-AO725>
	 <CA+5PVA6iC6nNCp4XD3X-xvRLLVw91AQEVBHVMJmh87Mz7b1Drg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 14:12 -0400, Josh Boyer wrote:
> On Mon, Jun 2, 2014 at 1:59 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:
> >> On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
> >> > On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> >> > > A ksummit-discuss email thread looked at the difficulty recruiting
> >> > > and retaining reviewers.
> >> >
> >> > []
> >> >
> >> > > Paul Walmsley also noted the need for patch
> >> > > submitters to know who the key reviewers are and suggested adding an
> >> > > "R:" tag to the MAINTAINERS file to record this information on a
> >> > > per-subsystem basis.
> >> >
> >> > I'm not sure of the value of this.
> >> >
> >> > Why not just mark the actual reviewers as maintainers?
> >>
> >> As discussed in the kernel summit discussion, being a regular patch
> >> reviewer isn't the same thing as being *the* maintainer.
> >
> > I think it's not particularly important or valuable
> > here to make that distinction.
> >
> > What real difference does it make?
> 
> It depends.  If the Maintainer moves to a model where patches must be
> reviewed before they are added to the tree, then having a designated
> reviewer helps.  It gives the patch submitter another person to
> include, and if the Reviewer acks a patch, they know it's much more
> likely to make it in-tree.
> 
> If the tree isn't managed that way, then Reviewer/Maintainer is a bit
> less distinctive, but it still provides at least some indication that
> a "maintainer" looked at the patch instead of having it just sit on
> the list.

So effectively, nothing.

