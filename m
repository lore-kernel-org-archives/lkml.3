Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3JDSx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:53:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3JDSx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:53:26 -0400
Date: Fri, 4 Oct 2013 20:46:14 +0200
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
Subject: [PATCH 0/5] rcusync: validations + dtor + exclusive
Message-ID: <20131004184614.GA17536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of Peter's "[PATCH 0/3] Optimize the cpu hotplug locking"
series.

It seems that Paul and Peter agree with 1-3, and they are simple.

4-5 should be ignored without the explicit ack. Peter seems to
dislike the exclusive mode. I disagree but I am not going to argue.
(well, at least right now ;)

Oleg.

 include/linux/rcusync.h |   80 ++++++++++++++++++++------------------
 kernel/cpu.c            |    2 +-
 kernel/rcusync.c        |   98 +++++++++++++++++++++++++++++++++-------------
 3 files changed, 113 insertions(+), 67 deletions(-)

