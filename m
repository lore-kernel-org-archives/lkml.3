Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3KLRYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:24:20 -0500
Received: from mail.efficios.com ([78.47.125.74]:50346 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab3KLRYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:24:17 -0500
Date: Tue, 12 Nov 2013 17:24:19 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Message-ID: <1977064126.65236.1384277059506.JavaMail.zimbra@efficios.com>
In-Reply-To: <119843495.65234.1384277039175.JavaMail.zimbra@efficios.com>
Subject: [RELEASE] Userspace RCU 0.7.9
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: Userspace RCU 0.7.9
Thread-Index: piR/xxzA8EyAkYN58A9O+h6Vt931mg==
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
2013-11-12 Userspace RCU 0.7.9
        * tls-compat: fix comment typo
        * Keep ABI compatible with already compiled LGPL applications
        * Fix: tls-compat multi-lib conflict
        * gcc warning fixes: -Wsign-compare and -Wextra
        * Fix: urcu-qsbr: reversed logic on RCU_DEBUG
        * Fix: urcu-bp segfault in glibc pthread_kill()
        * Fix urcu-bp: don't move registry
        * Fix: compat futex duplicated lock and completion
        * Fix: i386 compat code duplicated mutex instances
        * Fix: urcu-bp: Bulletproof RCU arena resize bug
        * Fix: test_mutex.c uninitialized mutex

Project website: http://urcu.so
Download link: http://urcu.so/files/
Git repository: git://git.urcu.so/urcu.git

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
