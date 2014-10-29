Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbaJ2Q1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:27:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934559AbaJ2Q1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:27:33 -0400
Date: Wed, 29 Oct 2014 17:27:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 0/4] ftrace: Add dynamic trampoline support
In-Reply-To: <20141027182702.778680710@goodmis.org>
Message-ID: <alpine.LNX.2.00.1410291053180.20256@pobox.suse.cz>
References: <20141027182702.778680710@goodmis.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Steven Rostedt wrote:

> This adds the allocation of dynamic trampolines. It still does not
> allow for dynamic ftrace_ops to use them on CONFIG_PREEMPT systems.
> That will come in 3.20, as I want to test out call_rcu_tasks() for
> a bit first on my own boxes.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> for-next
> 
> Head SHA1: 9fd7caf67913fbf35d834beaa8f9764d733a9236
> 
> 
> Steven Rostedt (Red Hat) (4):
>       ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
>       ftrace/x86: Show trampoline call function in enabled_functions
>       ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines
>       ftrace: Add more information to ftrace_bug() output

FWIW I just did a very quick test, and kGraft seems to run flawlessly on 
top of this.

Thanks,

-- 
Jiri Kosina
SUSE Labs
