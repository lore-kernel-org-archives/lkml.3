Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaGHN4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:56:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55059 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaGHN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:56:08 -0400
Date: Tue, 8 Jul 2014 06:56:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH tip/core/rcu 14/17] rcu: remove CONFIG_PROVE_RCU_DELAY
Message-ID: <20140708135600.GG4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404807066.26126.9.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404807066.26126.9.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070813-8236-0000-0000-000003AB2E11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:11:06AM +0200, Paul Bolle wrote:
> Paul,
> 
> On Mon, 2014-07-07 at 15:38 -0700, Paul E. McKenney wrote:
> > The CONFIG_PROVE_RCU_DELAY Kconfig parameter doesn't appear to be very
> > effective at finding race conditions, so this commit removes it.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > ---
> >  kernel/rcu/tree.c                                       | 5 -----
> >  kernel/rcu/update.c                                     | 3 ---
> 
> The commit explanation implies that this patch would also remove the
> entry for PROVE_RCU_DELAY in lib/Kconfig.debug. Is there any reason to
> keep it after this patch?
> 
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE01   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE02   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE02-T | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE03   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE04   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE05   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE06   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE07   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE08   | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE08-T | 1 -
> >  tools/testing/selftests/rcutorture/configs/rcu/TREE09   | 1 -
> >  13 files changed, 19 deletions(-)
> 
> This doesn't touch a few other references in
> tools/testing/selftests/rcutorture/. I have no idea how these tests
> work, so I assume these references are still needed. Is that correct?

Good catch on both counts, fixed.

							Thanx, Paul

