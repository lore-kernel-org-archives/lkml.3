Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaIVQrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:47:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbaIVQrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:47:22 -0400
Date: Mon, 22 Sep 2014 18:44:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] signal: simplify/document lock_task_sighand() logic
Message-ID: <20140922164404.GA28910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Steven Rostedt wrote:
>
> You know, this code could use some comments. I may send you a patch,
> because that __lock_task_sighand() is doing a lot of subtle things and
> there's not a single comment explaining it :-(

Sorry for delay.

Does 2/2 look clear enough?

Oleg.

 kernel/fork.c   |    5 ++++-
 kernel/signal.c |   43 ++++++++++++++++++++++++-------------------
 2 files changed, 28 insertions(+), 20 deletions(-)

