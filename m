Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3HTNkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:40:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34660 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3HTNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:40:21 -0400
Date: Tue, 20 Aug 2013 06:39:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation updates for 3.12
Message-ID: <20130820133950.GA29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818012522.GA27015@linux.vnet.ibm.com>
 <1376982570.2737.62@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376982570.2737.62@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082013-7606-0000-0000-00000E78808A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:09:30AM -0500, Rob Landley wrote:
> On 08/17/2013 08:25:22 PM, Paul E. McKenney wrote:
> >Hello!
> >
> >This series provides a few documentation updates:
> >
> >1.	Update rcu_barrier() documentation to note that it no longer is
> >	guaranteed to wait for a full grace period.  This guarantee was
> >	a victim of energy efficiency.
> >
> >2.	Update RTFP documentation.
> >
> >3.	Fix a control-dependency example in the memory-barriers
> >	documentation.
> 
> Acked-by: Rob Landley <rob@landley.net>

Glad you like it!

> (I'm just happy you don't have gratuitous quizzes mixed through it...)

That comes later.  ;-)

There actually is a method to the quick-quiz madness, but perhaps
something for another time.

							Thanx, Paul

