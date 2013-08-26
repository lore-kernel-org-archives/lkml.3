Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3HZOSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:18:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3HZOSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:18:52 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wom5GMh1gUkA:10 a=K5CnSjgaiocA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=HYTzF2Oq1SkA:10 a=1psFuYWTBHozATT-7xkA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 10:18:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [guv 04/16] core: Convert __get_cpu_var uses
Message-ID: <20130826141849.GA6276@home.goodmis.org>
References: <20130823190135.726207430@linux.com>
 <00000140ac8e2bdd-f0151a00-88ca-4d0b-adbc-007c514b6856-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140ac8e2bdd-f0151a00-88ca-4d0b-adbc-007c514b6856-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As Tejun said, each commit needs its own change log. Never expect a
change lgo from another commit to be read for changes in this commit.

> Index: linux/kernel/events/callchain.c
> Index: linux/kernel/events/core.c
> Index: linux/kernel/printk/printk.c
> Index: linux/kernel/rcutree.c
> Index: linux/kernel/sched/cputime.c
> Index: linux/kernel/sched/fair.c
> Index: linux/kernel/sched/rt.c
> Index: linux/kernel/time/tick-sched.c
> Index: linux/net/ipv4/syncookies.c
> Index: linux/net/ipv6/syncookies.c
> Index: linux/block/blk-iopoll.c
> Index: linux/block/blk-softirq.c
> Index: linux/fs/fscache/object.c
> Index: linux/include/linux/kernel_stat.h
> Index: linux/include/linux/kprobes.h
> Index: linux/include/linux/percpu.h
> Index: linux/include/net/netfilter/nf_conntrack.h
> Index: linux/kernel/hrtimer.c
> Index: linux/kernel/irq_work.c
> Index: linux/kernel/rcutree_plugin.h
> Index: linux/kernel/sched/clock.c
> Index: linux/kernel/sched/sched.h
> Index: linux/kernel/smp.c
> Index: linux/kernel/softirq.c
> Index: linux/kernel/time/tick-common.c
> Index: linux/kernel/time/tick-oneshot.c
> Index: linux/kernel/trace/ftrace.c
> Index: linux/kernel/user-return-notifier.c
> Index: linux/kernel/watchdog.c
> Index: linux/lib/radix-tree.c
> Index: linux/mm/memcontrol.c
> Index: linux/mm/memory-failure.c
> Index: linux/mm/page-writeback.c
> Index: linux/mm/swap.c
> Index: linux/mm/vmalloc.c
> Index: linux/mm/vmstat.c
> Index: linux/net/core/dev.c
> Index: linux/net/core/drop_monitor.c
> Index: linux/net/core/skbuff.c
> Index: linux/net/ipv4/tcp_output.c
> Index: linux/net/rds/ib_rdma.c
> Index: linux/kernel/timer.c
> Index: linux/kernel/trace/trace.c

This patch needs to be broken up per subsystem. Or are you just looking
for acks from all the maintainers here and you'll pull it in. If that's
the case, you should have Cc'd each of the maintainers of the files that
this touches.

-- Steve

