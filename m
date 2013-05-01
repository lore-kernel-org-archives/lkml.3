Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518Ab3EAPaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:30:06 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59700 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3EAP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:29:59 -0400
Message-ID: <1367422195.11020.46.camel@edumazet-glaptop>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Ingo Molnar <mingo@redhat.com>, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Wed, 01 May 2013 08:29:55 -0700
In-Reply-To: <20130501151752.GA7521@dyad.programming.kicks-ass.net>
References: <1367290378-29224-1-git-send-email-horms@verge.net.au>
	 <1367290378-29224-2-git-send-email-horms@verge.net.au>
	 <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg>
	 <20130430072944.GA13959@verge.net.au>
	 <alpine.LFD.2.00.1304301051260.1700@ja.ssi.bg>
	 <20130501091012.GB28253@dyad.programming.kicks-ass.net>
	 <20130501124637.GO3780@linux.vnet.ibm.com>
	 <20130501151752.GA7521@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 17:17 +0200, Peter Zijlstra wrote:
> On Wed, May 01, 2013 at 05:46:37AM -0700, Paul E. McKenney wrote:
> 
> > If the only goal is to allow preemption, and if long grace periods are
> > not a concern, then this alternate approach would work fine as well.
> 
> Hmm.. if that were the goal I'd like it to have a different name;
> cond_resched*() has always been about preemption.

BTW, I do not remember why cond_resched() is not an empty macro
when CONFIG_PREEMPT=y ?


