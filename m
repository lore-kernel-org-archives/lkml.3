Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaKZWFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:05:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:53347 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:05:49 -0500
Date: Wed, 26 Nov 2014 23:05:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 0/9 v2] ftrace/x86: Clean up of mcount.S code
In-Reply-To: <20141125115003.856641273@goodmis.org>
Message-ID: <alpine.DEB.2.11.1411262304010.3961@nanos>
References: <20141125115003.856641273@goodmis.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Steven Rostedt wrote:
> Steven Rostedt (Red Hat) (9):
>       ftrace/x86: Have static tracing also use ftrace_caller_setup
>       ftrace/x86: Move MCOUNT_SAVE_FRAME out of header file
>       ftrace/x86: Rename MCOUNT_SAVE_FRAME and add more detailed comments
>       ftrace/x86: Have save_mcount_regs store RIP in %rdi for first parameter
>       ftrace/x86: Simplify save_mcount_regs on getting RIP
>       ftrace/x86: Add macro MCOUNT_REG_SIZE for amount of stack used to save mcount regs
>       ftrace/x86: Have save_mcount_regs macro also save stack frames if needed
>       ftrace/x86: Get rid of ftrace_caller_setup
>       ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter

I took the last remaining cells of my review damaged brain together to
go through this with a fine comb. So far I could not find something,
but I might have missed the obvious.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
