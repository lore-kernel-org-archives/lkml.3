Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab3FSBMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:12:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49005 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932644Ab3FSBMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:12:31 -0400
Date: Tue, 18 Jun 2013 21:12:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [RELEASE] Userspace RCU 0.7.7
Message-ID: <20130619011226.GA20509@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
data synchronization library provides read-side access which scales
linearly with the number of cores. It does so by allowing multiples
copies of a given data structure to live at the same time, and by
monitoring the data structure accesses to detect grace periods after
which memory reclamation is possible.

liburcu-cds provides efficient data structures based on RCU and
lock-free algorithms. Those structures include hash tables, queues,
stacks, and doubly-linked lists.

Changelog:

2013-06-18 Userspace RCU 0.7.7
        * rculfhash: document destroy context limitation
        * Fix: Use a filled signal mask to disable all signals
        * Document: rculfhash destroy and resize side-effect in 0.7
        * Add "sparc" host cpu to configure.ac
        * Fix: tests/api.h use cpuset.h
        * Fix hurd-i386: move cpuset tests outside of sched_setaffinity
          conditional
        * Fix tests: finer-grained use of CPU_SET, CPU_ZERO and cpu_set_t
        * Test for CPU_SET
        * Fix build on architectures with HAVE_SCHED_GETCPU but without
          HAVE_SYSCONF
        * README: document that Clang 3.0 (based on LLVM 3.0) is supported
        * clang: silence "unused expression result" warning
        * rculfhash: add assertions on node alignment
        * uatomic: style fix

Project website: http://lttng.org/urcu
Download link: http://lttng.org/files/urcu/

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
