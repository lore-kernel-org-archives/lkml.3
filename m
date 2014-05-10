Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaEJTeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:34:25 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37252 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaEJTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:34:24 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 10 May 2014 12:34:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 32/45] torture: Better summary diagnostics
 for build failures
Message-ID: <20140510193411.GB12079@thin>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-32-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507221139.GP27924@cloud>
 <20140510004838.GH8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510004838.GH8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:48:38PM -0700, Paul E. McKenney wrote:
> On Wed, May 07, 2014 at 03:11:39PM -0700, josh@joshtriplett.org wrote:
> > On Mon, Apr 28, 2014 at 05:25:20PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > The reaction of kvm-recheck.sh is obscure at best, and easy to miss
> > > completely.  This commit therefore prints "BUG: Build failed" in the
> > > summary at the end of a run.
> > 
> > This commit also changes a dozen other things about the output that this
> > commit message does not document. :)
> 
> Well, I don't know about a dozen, but I did upgrade the commit message to
> read as follows:
> 
> 	The reaction of kvm-recheck.sh is obscure at best, and easy to
> 	miss completely.  This commit therefore prints "BUG: Build failed"
> 	in the summary at the end of a run.  This commit also adds the
> 	line of dashes in cases where performance info is not available,
> 	and also avoids printing nonsense diagnostics in cases where
> 	some of the normal test output is not available.

What about the change to kvm-test-1-run.sh?

- Josh Triplett
