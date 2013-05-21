Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3EURdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:33:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33651 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3EURdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:33:54 -0400
X-Originating-IP: 173.246.103.110
Date: Tue, 21 May 2013 10:33:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/2] Documentation changes for 3.11
Message-ID: <20130521173344.GB3878@jtriplet-mobl1>
References: <20130520144934.GA29947@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520144934.GA29947@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 07:49:34AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> A pair of documentation changes.  These are not directly related to RCU,
> but if no one adopts them, I will send them up with the RCU commits.  The
> patches are as follows:
> 
> 1.	Changes to the new Documentation/timers/NO_HZ.txt documentation
> 	based on review comments from Sedat Dilek.
> 
> 2.	Document ways of turning off the scheduling-clock tick even when
> 	there is more than one runnable task on a given CPU.
> 
> 3.	Document ways of avoiding OS jitter form the kworker workqueue
> 	kthreads.

For some reason these are numbered 1/2, 2/2, and 1/1.

In any case, for all three:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
