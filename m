Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaKZXNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:13:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:61336 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634AbaKZXNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:13:30 -0500
Date: Wed, 26 Nov 2014 18:13:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 0/9 v2] ftrace/x86: Clean up of mcount.S code
Message-ID: <20141126181328.6f517d65@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.11.1411262304010.3961@nanos>
References: <20141125115003.856641273@goodmis.org>
	<alpine.DEB.2.11.1411262304010.3961@nanos>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 23:05:48 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 25 Nov 2014, Steven Rostedt wrote:
> > Steven Rostedt (Red Hat) (9):
> >       ftrace/x86: Have static tracing also use ftrace_caller_setup
> >       ftrace/x86: Move MCOUNT_SAVE_FRAME out of header file
> >       ftrace/x86: Rename MCOUNT_SAVE_FRAME and add more detailed comments
> >       ftrace/x86: Have save_mcount_regs store RIP in %rdi for first parameter
> >       ftrace/x86: Simplify save_mcount_regs on getting RIP
> >       ftrace/x86: Add macro MCOUNT_REG_SIZE for amount of stack used to save mcount regs
> >       ftrace/x86: Have save_mcount_regs macro also save stack frames if needed
> >       ftrace/x86: Get rid of ftrace_caller_setup
> >       ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter
> 
> I took the last remaining cells of my review damaged brain together to
> go through this with a fine comb. So far I could not find something,
> but I might have missed the obvious.
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

-- Steve
