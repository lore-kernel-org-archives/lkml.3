Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3KWEAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 23:00:21 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44102 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3KWEAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 23:00:18 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 22 Nov 2013 20:00:05 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v3 tip/core/locking 0/3] Memory-barrier documentation
 updates
Message-ID: <20131123040005.GA2090@leaf>
References: <20131122192657.GA11924@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122192657.GA11924@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:26:57AM -0800, Paul E. McKenney wrote:
> Hello!
> 
> This series applies some long-needed updates to memory-barriers.txt:
> 
> 1.	Add ACCESS_ONCE() calls where needed to ensure their inclusion
> 	in code copy-and-pasted from this file.
> 
> 2.	Add long atomic examples alongside the existing atomics.
> 
> 3.	Prohibit architectures supporting the Linux kernel from
> 	speculating stores.
> 
> Changes from v2:
> 
> o	Update examples so that that load against which the subsequent
> 	store is to be ordered is part of the "if" condition.
> 
> o	Add an example showing how the compiler can remove "if"
> 	conditions and how to prevent it from doing so.
> 
> o	Add ACCESS_ONCE() to the compiler-barrier section.
> 
> o	Add a sentence noting that transitivity requires smp_mb().
> 
> Changes from v1:
> 
> o	Combined with Peter Zijlstra's speculative-store-prohibition patch.
> 
> o	Added more pitfalls to avoid when prohibiting speculative
> 	stores, along with how to avoid them.
> 
> o	Applied Josh Triplett's review comments.

For v3, all three patches:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
