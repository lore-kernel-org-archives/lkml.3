Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaDOSg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaDOSgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:36:54 -0400
Date: Tue, 15 Apr 2014 20:36:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND2 00/11] cleanup/fix allow_signal/disallow_signal
Message-ID: <20140415183625.GA13371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added RESEND2 to avoid the confusion, sorry to all for spam.

To remind, this doesn't depend on (or conflict with) the previous patch
"kill CLONE_KERNEL, change kernel_thread(kernel_init) to avoid CLONE_SIGHAND"
I sent.

Oleg.

 arch/m68k/include/asm/signal.h |    9 ----
 arch/x86/include/asm/signal.h  |    6 ---
 fs/jffs2/background.c          |   12 +++--
 include/linux/sched.h          |    3 -
 include/linux/signal.h         |   21 +++++++--
 kernel/exit.c                  |   39 -----------------
 kernel/kmod.c                  |    5 +--
 kernel/signal.c                |   90 ++++++++++++++++++---------------------
 8 files changed, 66 insertions(+), 119 deletions(-)


