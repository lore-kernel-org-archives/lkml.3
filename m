Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab3B1JNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:13:10 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61662 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3B1JNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:13:06 -0500
Date: Thu, 28 Feb 2013 10:13:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH][3.9] ftrace: Update the kconfig for DYNAMIC_FTRACE
Message-ID: <20130228091306.GA6950@gmail.com>
References: <1362021805.1231.18.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362021805.1231.18.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> At ELC I watched a presentation by Ezequiel about a tool he wrote to
> analyze memory wasted by kmalloc and friends. He incorrectly stated that
> you need to enable DYNAMIC_FTRACE in order to get events. I pointed out
> that this was incorrect, but he showed me that the prompt for
> DYNAMIC_FTRACE said it enabled/disabled ftrace tracepoints dynamically.
> And sure enough, it did say that. But this was written when ftrace was
> first created and hasn't been updated since. It was written well before
> tracepoints made it into the kernel. Heck, it even references that damn
> daemon!
> 
> As the merge window is still opened, and even if it wasn't, this fix
> should go mainline ASAP. It should also go into stable. This is
> definitely a bug. It may only be documentation (which means it's low
> risk to add), but it's documentation on how to set up your kernel, and
> that being wrong creates unexpected results for the user. Just like any
> other bug would.
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: db05021d49a994ee40a9735d9c3cb0060c9babb8
> 
> 
> Steven Rostedt (1):
>       ftrace: Update the kconfig for DYNAMIC_FTRACE
> 
> ----
>  kernel/trace/Kconfig |   24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)

Pulled, thanks Steve!

	Ingo
