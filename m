Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3LMOS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:18:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3LMOS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:18:56 -0500
Date: Fri, 13 Dec 2013 15:18:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v6 tip/core/locking 3/8]
 Documentation/memory-barriers.txt: Prohibit speculative writes
Message-ID: <20131213141819.GN21999@twins.programming.kicks-ass.net>
References: <20131211215850.GA810@linux.vnet.ibm.com>
 <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386799151-2219-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131212131710.GE5806@gmail.com>
 <20131212150844.GZ4208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212150844.GZ4208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 07:08:44AM -0800, Paul E. McKenney wrote:
> On Thu, Dec 12, 2013 at 02:17:10PM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > No SMP architecture currently supporting Linux allows speculative writes,
> > > so this commit updates Documentation/memory-barriers.txt to prohibit
> > > them in Linux core code.  It also records restrictions on their use.
> > > 
> > > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > The signoff sequence looks weird here. If this came from Peter 
> > originally, did you mean:
> > 
> >   From: Peter Zijlstra <peterz@infradead.org>
> > 
> > instead of "From: Paul ..." ?
> 
> Indeed I did!  I will fix.

Well Paul did rewrite the entire thing into something far better than
what I started out with. I don't mind him dropping my SOB over his own.
I'll settle for an reviewed-by on this ;-)
