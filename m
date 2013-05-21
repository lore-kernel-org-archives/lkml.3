Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3EUVNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:13:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45650 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3EUVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:13:26 -0400
Date: Tue, 21 May 2013 14:12:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/2] Documentation changes for 3.11
Message-ID: <20130521211229.GW3578@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130520144934.GA29947@linux.vnet.ibm.com>
 <20130521173344.GB3878@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521173344.GB3878@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052121-5518-0000-0000-00000EE2A6AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:33:44AM -0700, Josh Triplett wrote:
> On Mon, May 20, 2013 at 07:49:34AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > A pair of documentation changes.  These are not directly related to RCU,
> > but if no one adopts them, I will send them up with the RCU commits.  The
> > patches are as follows:
> > 
> > 1.	Changes to the new Documentation/timers/NO_HZ.txt documentation
> > 	based on review comments from Sedat Dilek.
> > 
> > 2.	Document ways of turning off the scheduling-clock tick even when
> > 	there is more than one runnable task on a given CPU.
> > 
> > 3.	Document ways of avoiding OS jitter form the kworker workqueue
> > 	kthreads.
> 
> For some reason these are numbered 1/2, 2/2, and 1/1.

That was my unsuccessful attempt to fool git-sent-email.  Now that
3.10-rc2 is out, there is no longer any need to fool it.  (Patch 3
depended on a patch that was on a different branch that I didn't want
to merge into the main RCU branch, but now all of that is in mainline,
so I just rebase onto 3.10-rc2.)

> In any case, for all three:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you for the review!

							Thanx, Paul

