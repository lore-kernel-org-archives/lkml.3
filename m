Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaCSSGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:06:21 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:46457 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaCSSGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:06:19 -0400
Message-ID: <1395252376.28137.26.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 11:06:16 -0700
In-Reply-To: <20140319170829.GD8557@laptop.programming.kicks-ass.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 18:08 +0100, Peter Zijlstra wrote:
> On Wed, Mar 19, 2014 at 04:47:05PM +0100, Peter Zijlstra wrote:
> > > I reverted b0c29f79ecea0b6fbcefc999e70f2843ae8306db on top of v3.14-rc6 and confirmed that
> > > reverting the commit solved the problem.
> > 
> > Joy,.. let me look at that with ppc in mind.

errr... just sat down to check email this morning. CC'ing Paul as for
any subtle barrier issues.

