Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477Ab3EAPTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:19:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3EAPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:19:39 -0400
Date: Wed, 1 May 2013 17:17:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
Message-ID: <20130501151752.GA7521@dyad.programming.kicks-ass.net>
References: <1367290378-29224-1-git-send-email-horms@verge.net.au>
 <1367290378-29224-2-git-send-email-horms@verge.net.au>
 <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg>
 <20130430072944.GA13959@verge.net.au>
 <alpine.LFD.2.00.1304301051260.1700@ja.ssi.bg>
 <20130501091012.GB28253@dyad.programming.kicks-ass.net>
 <20130501124637.GO3780@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501124637.GO3780@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:46:37AM -0700, Paul E. McKenney wrote:

> If the only goal is to allow preemption, and if long grace periods are
> not a concern, then this alternate approach would work fine as well.

Hmm.. if that were the goal I'd like it to have a different name;
cond_resched*() has always been about preemption.

> Of course, both approaches assume that the caller is in a place
> where having all RCU-protected data disappear is OK!

Quite :-)
