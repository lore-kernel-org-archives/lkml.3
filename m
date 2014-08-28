Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaH1SMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:12:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39689 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1SMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:12:13 -0400
Date: Thu, 28 Aug 2014 11:12:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/3] Documentation updates for 3.18
Message-ID: <20140828181208.GA22865@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-8236-0000-0000-000004F82261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides a few documentation updates for the newish
control-dependency section for memory-barriers.txt:

1.	Fix control-dependency no-transitivity example.

2.	Add barrier() to control-dependency example.

3.	Fix description of 2-legged-if-based control dependencies.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/memory-barriers.txt |  140 ++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 68 deletions(-)

