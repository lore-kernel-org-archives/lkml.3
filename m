Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3JDTcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:32:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3JDTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:32:12 -0400
Date: Fri, 4 Oct 2013 21:32:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] rcusync: validations + dtor + exclusive
Message-ID: <20131004193203.GV15690@laptop.programming.kicks-ass.net>
References: <20131004184614.GA17536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004184614.GA17536@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 08:46:14PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> On top of Peter's "[PATCH 0/3] Optimize the cpu hotplug locking"
> series.
> 
> It seems that Paul and Peter agree with 1-3, and they are simple.

Yeah, ACK on those.. shall I pick them up and stuff them through tip
with the rest of the lot?

> 4-5 should be ignored without the explicit ack. Peter seems to
> dislike the exclusive mode. I disagree but I am not going to argue.
> (well, at least right now ;)

Lets have another few rounds of email on that one; maybe I'll get used
to it :-)
