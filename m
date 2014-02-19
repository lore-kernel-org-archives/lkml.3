Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaBSRp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:45:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56692 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754257AbaBSRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:45:55 -0500
Date: Wed, 19 Feb 2014 12:45:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] sched/deadline: Fix bad accounting of nr_running
Message-ID: <20140219124553.01577dd3@gandalf.local.home>
In-Reply-To: <5304AE4E.6030208@gmail.com>
References: <20140214235946.60a89b65@gandalf.local.home>
	<53022F2D.8040301@gmail.com>
	<20140218215012.209059c0@gandalf.local.home>
	<20140219084618.GF27965@twins.programming.kicks-ass.net>
	<53048849.3000601@gmail.com>
	<5304AE4E.6030208@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 14:14:54 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:

> Steven, could you test it?

OK, I tested it on my x86_64 box that was also causing troubles.

Please fix up the whitespace issues and send a formal patch to Peter.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Added-bys-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
