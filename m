Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaCHNwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 08:52:11 -0500
Received: from mail.efficios.com ([78.47.125.74]:60318 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaCHNwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 08:52:08 -0500
Date: Sat, 8 Mar 2014 13:52:10 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        rp@svcs.cs.pdx.edu
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Alan Stern <stern@rowland.harvard.edu>
Message-ID: <2003732716.34418.1394286730587.JavaMail.zimbra@efficios.com>
In-Reply-To: <430198093.34414.1394286539155.JavaMail.zimbra@efficios.com>
Subject: [RELEASE] Userspace RCU 0.7.12 and 0.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [190.92.114.62]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: Userspace RCU 0.7.12 and 0.8.4
Thread-Index: BIOhNi0cH9678s+AsZ5BCsZo4GOSUQ==
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

Noteworthy:

There is a minor imperfection in the prior version (0.8.3/0.7.11)
corrected by this release. However, it is not required for
correctness. We are doing this release because clients will
base their packages (and did their testing) on those commits.

Changelog:
2014-03-08 Userspace RCU 0.8.4
        * Fix: move wait loop increment before first conditional block

2014-03-08 Userspace RCU 0.7.12
        * Fix: move wait loop increment before first conditional block

Project website: http://urcu.so
Download link: http://urcu.so/files/
Git repository: git://git.urcu.so/urcu.git

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
