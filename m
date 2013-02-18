Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3BRDmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:42:46 -0500
Received: from mout.gmx.net ([212.227.15.19]:64608 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab3BRDmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:42:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18P43FbOUIPZ3yvggFp6ogQ0Mm/UysfkuuNNFES6n
	wLpLjGjdXdNTFQ
Message-ID: <1361158953.14352.17.camel@marge.simpson.net>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Mon, 18 Feb 2013 04:42:33 +0100
In-Reply-To: <1361138089.23152.141.camel@gandalf.local.home>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
	 <1361031150.23152.133.camel@gandalf.local.home>
	 <1361082363.6088.21.camel@marge.simpson.net>
	 <1361085245.28353.3.camel@marge.simpson.net>
	 <1361138089.23152.141.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-17 at 16:54 -0500, Steven Rostedt wrote:
> On Sun, 2013-02-17 at 08:14 +0100, Mike Galbraith wrote:
> 
> > (And puts a dent in x264 ultrafast) 
 
> What about my last patch? The one that avoids idle_balance() if the
> previous task was in a task_uninterruptible state. That one gave the
> same performance increase that removing idle_balance() did on my box.

I didn't try it, figuring it was pretty much the same as turning it off,
but just did.  Patch (-typo) has no effect on either x264 or hackbench
(surely will for -rt, but rt tasks here aren't sent to burn in rt hell).

-Mike

