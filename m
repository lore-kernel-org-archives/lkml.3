Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3D0QRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 12:17:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54140 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3D0QRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 12:17:39 -0400
Date: Sat, 27 Apr 2013 09:17:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, Ingo Molnar <mingo@redhat.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, dhaval.giani@gmail.com
Subject: Re: [PATCH 2/2] ipvs: Use cond_resched_rcu_lock() helper when
 dumping connections
Message-ID: <20130427161732.GA3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1366940708-10180-1-git-send-email-horms@verge.net.au>
 <1366940708-10180-3-git-send-email-horms@verge.net.au>
 <20130426080313.GC8669@dyad.programming.kicks-ass.net>
 <20130426154547.GC3860@linux.vnet.ibm.com>
 <20130426171948.GA31467@dyad.programming.kicks-ass.net>
 <20130426174815.GI3860@linux.vnet.ibm.com>
 <1367000815.8964.243.camel@edumazet-glaptop>
 <20130426190428.GJ3860@linux.vnet.ibm.com>
 <20130427071814.GA31700@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130427071814.GA31700@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042716-7606-0000-0000-00000ADCF911
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 09:18:15AM +0200, Peter Zijlstra wrote:
> > In the worst case, I
> > can fire up a prio 99 kthread on each CPU and send that kthread a
> > wakeup from RCU's rcu_gp_fqs() code.
> 
> You just know that's going to be _so_ popular ;-)

;-) ;-) ;-)

I must confess that I would prefer a somewhat less heavy-handed approach.

							Thanx, Paul

