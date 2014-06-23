Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaFWPtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:49:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:48904 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbaFWPtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="552066271"
Date: Mon, 23 Jun 2014 08:49:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, dave.hansen@intel.com, cl@gentwo.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623154931.GF8178@tassilo.jf.intel.com>
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <20140623062615.GB19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623062615.GB19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On the topic of these threads; I recently noticed RCU grew a metric ton
> of them, I found some 75 rcu kthreads on my box, wth up with that?

It seems like RCU is growing in complexity all the time.

Can it be put on a diet in general? 

No more new CONFIGs please either.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
