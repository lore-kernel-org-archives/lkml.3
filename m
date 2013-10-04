Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JDV3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:29:08 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40929 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3JDV3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:29:05 -0400
Date: Fri, 4 Oct 2013 14:28:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] rcusync: validations + dtor + exclusive
Message-ID: <20131004212858.GN5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131004184614.GA17536@redhat.com>
 <20131004193203.GV15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004193203.GV15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100421-5806-0000-0000-000022F5FA42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:32:03PM +0200, Peter Zijlstra wrote:
> On Fri, Oct 04, 2013 at 08:46:14PM +0200, Oleg Nesterov wrote:
> > Hello.
> > 
> > On top of Peter's "[PATCH 0/3] Optimize the cpu hotplug locking"
> > series.
> > 
> > It seems that Paul and Peter agree with 1-3, and they are simple.
> 
> Yeah, ACK on those.. shall I pick them up and stuff them through tip
> with the rest of the lot?

I am good with that.

> > 4-5 should be ignored without the explicit ack. Peter seems to
> > dislike the exclusive mode. I disagree but I am not going to argue.
> > (well, at least right now ;)
> 
> Lets have another few rounds of email on that one; maybe I'll get used
> to it :-)

;-) ;-) ;-)

							Thanx, Paul

