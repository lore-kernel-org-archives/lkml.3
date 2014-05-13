Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaEMT0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:26:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58556 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaEMT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:26:01 -0400
Date: Tue, 13 May 2014 12:25:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 32/45] torture: Better summary diagnostics
 for build failures
Message-ID: <20140513192554.GQ18164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-32-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507221139.GP27924@cloud>
 <20140510004838.GH8754@linux.vnet.ibm.com>
 <20140510193411.GB12079@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510193411.GB12079@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051319-7164-0000-0000-000001B9CF17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 12:34:12PM -0700, Josh Triplett wrote:
> On Fri, May 09, 2014 at 05:48:38PM -0700, Paul E. McKenney wrote:
> > On Wed, May 07, 2014 at 03:11:39PM -0700, josh@joshtriplett.org wrote:
> > > On Mon, Apr 28, 2014 at 05:25:20PM -0700, Paul E. McKenney wrote:
> > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > The reaction of kvm-recheck.sh is obscure at best, and easy to miss
> > > > completely.  This commit therefore prints "BUG: Build failed" in the
> > > > summary at the end of a run.
> > > 
> > > This commit also changes a dozen other things about the output that this
> > > commit message does not document. :)
> > 
> > Well, I don't know about a dozen, but I did upgrade the commit message to
> > read as follows:
> > 
> > 	The reaction of kvm-recheck.sh is obscure at best, and easy to
> > 	miss completely.  This commit therefore prints "BUG: Build failed"
> > 	in the summary at the end of a run.  This commit also adds the
> > 	line of dashes in cases where performance info is not available,
> > 	and also avoids printing nonsense diagnostics in cases where
> > 	some of the normal test output is not available.
> 
> What about the change to kvm-test-1-run.sh?

Right you are!

	The reaction of kvm-recheck.sh is obscure at best, and easy to
	miss completely.  This commit therefore prints "BUG: Build failed"
	in the summary at the end of a run.  This commit also adds the
	line of dashes in cases where performance info is not available,
	and also avoids printing nonsense diagnostics in cases where
	some of the normal test output is not available.  In addition,
	this commit saves off the .config file even when the build fails.

							Thanx, Paul

