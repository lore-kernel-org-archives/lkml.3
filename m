Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaBQVr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:47:27 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45533 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaBQVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:47:25 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 13:47:16 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/6] Documentation changes for 3.15
Message-ID: <20140217214716.GD7941@thin>
References: <20140217212625.GA4083@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217212625.GA4083@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:26:25PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> This series provides a variety of documentation updates:
> 
> 1.	Update the documentation on actions to take to avoid frenetic
> 	call_rcu() invocations from exhausting memory, including a mention
> 	of internal-to-RCU avoidance measures.
> 
> 2.	Add a note to Documentation/memory-barriers.txt stating that
> 	ACCESS_ONCE() provides cache coherence for accesses to any
> 	single given variable.
> 
> 3.	Add an explicit statement that in control dependencies, the
> 	condition must include the load in question.
> 
> 4.	Add WQ_SYSFS workqueues as a work-offloading option in
> 	Documentation/kernel-per-CPU-kthreads.txt.
> 
> 5.	It turns out that some types of control dependencies require
> 	memory barriers, most notably when the exact same store is
> 	at the beginning of both the then-clause and the else-clause.
> 	Document this.
> 
> 6.	Fixups to RTFP.txt

I've replied to 1, 2, and 5 with comments.  For 3, 4, and 6:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
