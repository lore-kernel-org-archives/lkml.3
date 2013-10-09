Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3JIS5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3JIS5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:57:44 -0400
Date: Wed, 9 Oct 2013 20:50:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] rcusync: exclusive mode
Message-ID: <20131009185023.GA19264@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "[PATCH 0/6] Optimize the cpu hotplug locking -v2".

> OK.. I'll give up trying to wreck this stuff ;-)

This hopefully means I can resend this ;) at least for review/record.

Changes:
	- rediffed

	- added "#define gp_wait" for consistency with rss_lock

	- add __complete_locked() back

Oleg.

 include/linux/rcusync.h |   31 +++++++++++++++++--------------
 kernel/cpu.c            |    2 +-
 kernel/rcusync.c        |   29 +++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 21 deletions(-)

