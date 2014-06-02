Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaFBSRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:17:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37319 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaFBSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:17:06 -0400
Date: Mon, 2 Jun 2014 11:16:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602181658.GX22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401731968.7323.4.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060218-8236-0000-0000-000002CC9F83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:59:28AM -0700, Joe Perches wrote:
> On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:
> > On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
> > > On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> > > > A ksummit-discuss email thread looked at the difficulty recruiting
> > > > and retaining reviewers.
> > > 
> > > []
> > > 
> > > > Paul Walmsley also noted the need for patch
> > > > submitters to know who the key reviewers are and suggested adding an
> > > > "R:" tag to the MAINTAINERS file to record this information on a
> > > > per-subsystem basis.
> > > 
> > > I'm not sure of the value of this.
> > > 
> > > Why not just mark the actual reviewers as maintainers?
> > 
> > As discussed in the kernel summit discussion, being a regular patch
> > reviewer isn't the same thing as being *the* maintainer.
> 
> I think it's not particularly important or valuable
> here to make that distinction.
> 
> What real difference does it make?

In the particular case of Josh, none, at least from my viewpoint.  He of
course might or might not want to take on additional maintainership
responsibility at this particular point in time, in which case, I would
be more than happy to have him as a designated maintainer.

But there have been people who have found serious issues in RCU patches
who I would not trust as full maintainers.  The ability to find defects
is valuable in and of itself, and should be recognized as such, even
when not accompanied by the rest of the maintainership package.

							Thanx, Paul

