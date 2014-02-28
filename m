Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaB1WeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:34:14 -0500
Received: from mail.efficios.com ([78.47.125.74]:54439 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaB1WeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:34:13 -0500
Date: Fri, 28 Feb 2014 22:34:15 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Message-ID: <1929970380.32531.1393626855704.JavaMail.zimbra@efficios.com>
In-Reply-To: <1671875579.32530.1393626840963.JavaMail.zimbra@efficios.com>
Subject: [RELEASE] Userspace RCU 0.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.201.126.139]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: Userspace RCU 0.7.10
Thread-Index: OMnBWmJyudUPRwixMiFGTiLme7ZNmw==
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
2014-02-28 Userspace RCU 0.7.10
        * Fix: urcu-bp interaction with threads vs constructors/destructors
        * Fix undefined NULL pointer arithmetic
        * Blacklist ARM gcc 4.8.0, 4.8.1, 4.8.2
        * rculfhash: document max_nr_buckets = 0

Project website: http://urcu.so
Download link: http://urcu.so/files/
Git repository: git://git.urcu.so/urcu.git


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
