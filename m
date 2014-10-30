Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbaJ3Q5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:57:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:59159 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757327AbaJ3Q5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:57:04 -0400
Date: Thu, 30 Oct 2014 12:56:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 0/4] ftrace: Add dynamic trampoline support
Message-ID: <20141030125650.2427061e@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1410291053180.20256@pobox.suse.cz>
References: <20141027182702.778680710@goodmis.org>
	<alpine.LNX.2.00.1410291053180.20256@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 17:27:30 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 27 Oct 2014, Steven Rostedt wrote:
> 
> > This adds the allocation of dynamic trampolines. It still does not
> > allow for dynamic ftrace_ops to use them on CONFIG_PREEMPT systems.
> > That will come in 3.20, as I want to test out call_rcu_tasks() for
> > a bit first on my own boxes.
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > for-next
> > 
> > Head SHA1: 9fd7caf67913fbf35d834beaa8f9764d733a9236
> > 
> > 
> > Steven Rostedt (Red Hat) (4):
> >       ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
> >       ftrace/x86: Show trampoline call function in enabled_functions
> >       ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines
> >       ftrace: Add more information to ftrace_bug() output
> 
> FWIW I just did a very quick test, and kGraft seems to run flawlessly on 
> top of this.
> 

Does that mean I can add your Tested-by: for all these patches?

-- Steve
