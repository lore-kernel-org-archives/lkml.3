Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3JGQZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3JGQZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:25:06 -0400
Date: Mon, 7 Oct 2013 18:17:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sched/wait: Introduce prepare_to_wait_event()
Message-ID: <20131007161758.GA29749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of recent changes in wait.h from Peter.

This is the same patch we already discussed, just "intr" was renamed
to "__int".

As for __maybe_unused, I think it is not needed. This "__int" is always
used, even gcc won't generate the code due to "if (0)" check.

Oleg.

