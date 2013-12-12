Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LLPI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:08:56 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36874 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LLPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:08:52 -0500
Date: Thu, 12 Dec 2013 07:08:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v6 tip/core/locking 3/8]
 Documentation/memory-barriers.txt: Prohibit speculative writes
Message-ID: <20131212150844.GZ4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131211215850.GA810@linux.vnet.ibm.com>
 <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386799151-2219-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131212131710.GE5806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212131710.GE5806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121215-6688-0000-0000-000004720B6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 02:17:10PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > No SMP architecture currently supporting Linux allows speculative writes,
> > so this commit updates Documentation/memory-barriers.txt to prohibit
> > them in Linux core code.  It also records restrictions on their use.
> > 
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> The signoff sequence looks weird here. If this came from Peter 
> originally, did you mean:
> 
>   From: Peter Zijlstra <peterz@infradead.org>
> 
> instead of "From: Paul ..." ?

Indeed I did!  I will fix.

							Thanx, Paul

