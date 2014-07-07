Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaGGNWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:22:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbaGGNWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:22:30 -0400
Date: Mon, 7 Jul 2014 15:22:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
In-Reply-To: <20140704102142.7d276e4b@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1407071520370.1655@pobox.suse.cz>
References: <20140703200750.648550267@goodmis.org> <53B6AA0C.2080704@hitachi.com> <20140704102142.7d276e4b@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014, Steven Rostedt wrote:

> Well, I guess the answer to that is what do you consider the trampoline? 
> I'm currently considering it to be the assembly code that the 
> mcount/fentry call jumps to. We only have two trampolines (three if you 
> count the function graph code that will be called directly come 3.17). 
> Those two are the normal ftrace_caller and the ftrace_regs_caller. 

BTW, on those archs that support regs saving already, is there really a 
reson not to kill ftrace_caller and keep just ftrace_regs_caller?

-- 
Jiri Kosina
SUSE Labs
