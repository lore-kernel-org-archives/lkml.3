Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaEIADt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:03:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38044 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaEIADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:03:47 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7fd86d0000038e3-46-536c1b62f004
Content-transfer-encoding: 8BIT
Message-id: <1399593691.13268.58.camel@kjgkr>
Subject: Re: [BUG] kmemleak on __radix_tree_preload
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Fri, 09 May 2014 09:01:31 +0900
In-reply-to: <20140508152946.GA10470@localhost>
References: <1398390340.4283.36.camel@kjgkr> <20140501170610.GB28745@arm.com>
 <20140501184112.GH23420@cmpxchg.org> <1399431488.13268.29.camel@kjgkr>
 <20140507113928.GB17253@arm.com> <1399540611.13268.45.camel@kjgkr>
 <20140508092646.GA17349@arm.com> <1399541860.13268.48.camel@kjgkr>
 <20140508102436.GC17344@arm.com> <20140508150026.GA8754@linux.vnet.ibm.com>
 <20140508152946.GA10470@localhost>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zfd0k6Zxgg8ZFnBbvl/UwWqze5Gtx
	edccNot7a/6zWrzd/J3VgdVjzbw1jB6H37xn9tj0aRK7x4NDm1k8Pm+SC2CN4rJJSc3JLEst
	0rdL4MrYu2sbS8EU64qPSz8zNzAu1+1i5OSQEDCROHj3JzuELSZx4d56ti5GLg4hgWWMEouP
	TmeCKVp/djIrRGIRo8S+d0/YQBK8AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWneImYQW0jg
	FaNE44Y6iHJdiZu3joLNFBYwllg4tYEJpJVNQFti834DiHJFibf777KC2CJA5RfaprCArGUW
	OM4osefOX7C1LAKqEs9+TGMBsTkF9CWuNvQyQ9w2mVli4ZYHYAv4BUQlDi/czgzxgJLE7vZO
	dpAiCYF77BItZy9DTRKQ+Db5ENgDEgKyEpsOQNVLShxccYNlAqPELCRvzkJ4cxaSNxcwMq9i
	FE0tSC4oTkovMtIrTswtLs1L10vOz93ECInHvh2MNw9YH2JMBto4kVlKNDkfGM95JfGGxmZG
	FqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoExTqRBK+LAJ8ZP
	nwKOzfqY/OfhVQnllRaVy+as0HNbXeXr+fWtdUDO9QXe595l5+mZv8u8JO6ef38a2xN52w2n
	E0Sn8jGpHvUp4bR+wsH8cJLt6f6f2tc2XbnEbHByzuf82cfeztdYIX/GMG2qoeR7jQ9xxpXW
	jBNyj8iJ/XhzM3mqyAJzPddwJZbijERDLeai4kQAlvYVBd0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd0k6Zxgg+8zWSzeL+thtFi9ydfi
	8q45bBb31vxntXi7+TurA6vHmnlrGD0Ov3nP7LHp0yR2jweHNrN4fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsXfXNpaCKdYVH5d+Zm5gXK7bxcjJISFgIrH+
	7GRWCFtM4sK99WxdjFwcQgKLGCX2vXvCBpLgFRCU+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnz
	FjGD2EICrxglGjfUQZTrSty8dZQJxBYWMJZYOLWBCaSVTUBbYvN+A4hyRYm3+++CrRUBKr/Q
	NoUFZC2zwHFGiT13/oKtZRFQlXj2YxoLiM0poC9xtaGXGeK2ycwSC7c8AFvALyAqcXjhdmaI
	B5Qkdrd3sk9gFJqF5OxZCGfPQnL2AkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0f5M
	egfjqgaLQ4wCHIxKPLwvpmQHC7EmlhVX5h5ilOBgVhLhfbEMKMSbklhZlVqUH19UmpNafIgx
	GejyicxSosn5wESUVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MEU9NVqRPNvwgXbcy/nPaq4JrS8qLH3EX/NtZd2FCqGz92rJTJ+QV24vvxpTLb87yit+p
	8uGX6vE1r5+In/wb7yIaIaYjr701rirdUiqf6brBVbX3nR8+BX/ScXL79jU7ZNrZr9tXWMg6
	G8+OeMcXJZ6+WCScbxH/UsNU53txecse3tiy8KarEktxRqKhFnNRcSIA0tSSqzoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-08 (목), 16:29 +0100, Catalin Marinas:
> On Thu, May 08, 2014 at 04:00:27PM +0100, Paul E. McKenney wrote:
> > On Thu, May 08, 2014 at 11:24:36AM +0100, Catalin Marinas wrote:
> > > On Thu, May 08, 2014 at 10:37:40AM +0100, Jaegeuk Kim wrote:
> > > > 2014-05-08 (목), 10:26 +0100, Catalin Marinas:
> > > > > On Thu, May 08, 2014 at 06:16:51PM +0900, Jaegeuk Kim wrote:
> > > > > > 2014-05-07 (수), 12:39 +0100, Catalin Marinas:
> > > > > > > On Wed, May 07, 2014 at 03:58:08AM +0100, Jaegeuk Kim wrote:
> > > > > > > > unreferenced object 0xffff880004226da0 (size 576):
> > > > > > > >   comm "fsstress", pid 14590, jiffies 4295191259 (age 706.308s)
> > > > > > > >   hex dump (first 32 bytes):
> > > > > > > >     01 00 00 00 81 ff ff ff 00 00 00 00 00 00 00 00  ................
> > > > > > > >     50 89 34 81 ff ff ff ff b8 6d 22 04 00 88 ff ff  P.4......m".....
> > > > > > > >   backtrace:
> > > > > > > >     [<ffffffff816c02e8>] kmemleak_update_trace+0x58/0x80
> > > > > > > >     [<ffffffff81349517>] radix_tree_node_alloc+0x77/0xa0
> > > > > > > >     [<ffffffff81349718>] __radix_tree_create+0x1d8/0x230
> > > > > > > >     [<ffffffff8113286c>] __add_to_page_cache_locked+0x9c/0x1b0
> > > > > > > >     [<ffffffff811329a8>] add_to_page_cache_lru+0x28/0x80
> > > > > > > >     [<ffffffff81132f58>] grab_cache_page_write_begin+0x98/0xf0
> > > > > > > >     [<ffffffffa02e4bf4>] f2fs_write_begin+0xb4/0x3c0 [f2fs]
> > > > > > > >     [<ffffffff81131b77>] generic_perform_write+0xc7/0x1c0
> > > > > > > >     [<ffffffff81133b7d>] __generic_file_aio_write+0x1cd/0x3f0
> > > > > > > >     [<ffffffff81133dfe>] generic_file_aio_write+0x5e/0xe0
> > > > > > > >     [<ffffffff81195c5a>] do_sync_write+0x5a/0x90
> > > > > > > >     [<ffffffff811968d2>] vfs_write+0xc2/0x1d0
> > > > > > > >     [<ffffffff81196daf>] SyS_write+0x4f/0xb0
> > > > > > > >     [<ffffffff816dead2>] system_call_fastpath+0x16/0x1b
> > > > > > > >     [<ffffffffffffffff>] 0xffffffffffffffff
> > > > > > >
> > > > > > > OK, it shows that the allocation happens via add_to_page_cache_locked()
> > > > > > > and I guess it's page_cache_tree_insert() which calls
> > > > > > > __radix_tree_create() (the latter reusing the preloaded node). I'm not
> > > > > > > familiar enough to this code (radix-tree.c and filemap.c) to tell where
> > > > > > > the node should have been freed, who keeps track of it.
> > > > > > >
> > > > > > > At a quick look at the hex dump (assuming that the above leak is struct
> > > > > > > radix_tree_node):
> > > > > > >
> > > > > > > 	.path = 1
> > > > > > > 	.count = -0x7f (or 0xffffff81 as unsigned int)
> > > > > > > 	union {
> > > > > > > 		{
> > > > > > > 			.parent = NULL
> > > > > > > 			.private_data = 0xffffffff81348950
> > > > > > > 		}
> > > > > > > 		{
> > > > > > > 			.rcu_head.next = NULL
> > > > > > > 			.rcu_head.func = 0xffffffff81348950
> > > > > > > 		}
> > > > > > > 	}
> > > > > > >
> > > > > > > The count is a bit suspicious.
> > > > > > >
> > > > > > > From the union, it looks most likely like rcu_head information. Is
> > > > > > > radix_tree_node_rcu_free() function at the above rcu_head.func?
> > > > >
> > > > > Thanks for the config. Could you please confirm that 0xffffffff81348950
> > > > > address corresponds to the radix_tree_node_rcu_free() function in your
> > > > > System.map (or something else)?
> > > > 
> > > > Yap, the address is matched to radix_tree_node_rcu_free().
> > > 
> > > Cc'ing Paul as well, not that I blame RCU ;), but maybe he could shed
> > > some light on why kmemleak can't track this object.
> > 
> > Do we have any information on how long it has been since that data
> > structure was handed to call_rcu()?  If that time is short, then it
> > is quite possible that its grace period simply has not yet completed.
> 
> kmemleak scans every 10 minutes but Jaegeuk can confirm how long he has
> waited.

Under existing the kmemleak messeages, the fsstress test has been
running over 12 hours.
For sure now, I quit the test and umount the file system, which drops
the whole page caches used by f2fs.
Then do, echo scan > $DEBUGFS/kmemleak again, but there still exist a
bunch of leak messages.

The oldest one is:
unreferenced object 0xffff88007b167478 (size 576):
  comm "fsstress", pid 1636, jiffies 4294945289 (age 164639.728s)
  hex dump (first 32 bytes):
    01 00 00 00 81 ff ff ff 00 00 00 00 00 00 00 00  ................
    50 89 34 81 ff ff ff ff 90 74 16 7b 00 88 ff ff  P.4......t.{....
  backtrace:
[snip]

> 
> > It might also be that one of the CPUs is stuck (e.g., spinning with
> > interrupts disabled), which would prevent the grace period from
> > completing, in turn preventing any memory waiting for that grace period
> > from being freed.
> 
> We should get some kernel warning if it's stuck for too long but, again,
> Jaegeuk can confirm. I haven't managed to reproduce this on ARM systems.

There are no kernel warnings, but only kmemleak messages. The fsstress
has been well running without stucks.

> 
> > > My summary so far:
> > > 
> > > - radix_tree_node reported by kmemleak as it cannot find any trace of it
> > >   when scanning the memory
> > > - at allocation time, radix_tree_node is memzero'ed by
> > >   radix_tree_node_ctor(). Given that node->rcu_head.func ==
> > >   radix_tree_node_rcu_free, my guess is that radix_tree_node_free() has
> > >   been called
> > > - some time later, kmemleak still hasn't received any callback for
> > >   kmem_cache_free(node). Possibly radix_tree_node_rcu_free() hasn't been
> > >   called either since node->count is not NULL.
> > > 
> > > For RCU queued objects, kmemleak should still track references to them
> > > via rcu_sched_state and rcu_head members. But even if this went wrong, I
> > > would expect the object to be freed eventually and kmemleak notified (so
> > > just a temporary leak report which doesn't seem to be the case here).
> > 
> > OK, so you are saying that this memory has been in this state for quite
> > some time?
> 
> These leaks don't seem to disappear (time lapsed to be confirmed) and
> the object checksum not changed either (otherwise kmemleak would not
> report it).
> 
> > If the system is responsive during this time, I recommend building with
> > CONFIG_RCU_TRACE=y, then polling the debugfs rcu/*/rcugp files.  The value
> > of "*" will be "rcu_sched" for kernels built with CONFIG_PREEMPT=n and
> > "rcu_preempt" for kernels built with CONFIG_PREEMPT=y.

Got it. I'll do this first.
Thank you~ :)

> > 
> > If the number printed does not advance, then the RCU grace period is
> > stalled, which will prevent memory waiting for that grace period from
> > ever being freed.
> 
> Thanks for the suggestions
> 
> > Of course, if the value of node->count is preventing call_rcu() from
> > being invoked in the first place, then the needed grace period won't
> > start, much less finish.  ;-)
> 
> Given the rcu_head.func value, my assumption is that call_rcu() has
> already been called.
> 
> BTW, is it safe to have a union overlapping node->parent and
> node->rcu_head.next? I'm still staring at the radix-tree code but a
> scenario I have in mind is that call_rcu() has been raised for a few
> nodes, other CPU may have some reference to one of them and set
> node->parent to NULL (e.g. concurrent calls to radix_tree_shrink()),
> breaking the RCU linking. I can't confirm this theory yet ;)
> 

-- 
Jaegeuk Kim
Samsung

