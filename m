Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbbAPQmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:42:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555AbbAPQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:42:01 -0500
Date: Fri, 16 Jan 2015 17:41:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Steven Rostedt <rostedt@goodmis.org>
cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] ftrace: don't allow IPMODIFY without proper
 compiler support
In-Reply-To: <20150116113539.78c093ad@gandalf.local.home>
Message-ID: <alpine.LNX.2.10.1501161737320.1074@wotan.suse.de>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org>
 <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz> <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org> <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz> <20150107155701.4839545f63701412003edd88@linux-foundation.org>
 <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz> <54B3C1DD.6090400@hitachi.com> <alpine.LNX.2.00.1501132345080.4162@pobox.suse.cz> <20150113211223.18908f21@grimm.local.home> <alpine.LNX.2.00.1501140945520.4162@pobox.suse.cz> <alpine.LNX.2.00.1501151045580.4162@pobox.suse.cz>
 <20150116113539.78c093ad@gandalf.local.home>
User-Agent: Alpine 2.10 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Steven Rostedt wrote:

> Instead, make live kernel patching fail to load if fentry isn't 
> supported. IOW, instead of ftrace_ipmodify_supported, have a 
> live_kernel_patching_supported that could be based on fentry being used 
> or not.

I can live with that, we are handling non-fentry case ourselves already.

You expressed that you would accept such patch for ftrace in a past, so I 
thought I'll move it out from livepatching to ftrace. But if you don't 
want it now, that's not a big issue, and handling the possible fallout 
stays the responsibility of ftrace_ops "owner".

-- 
Jiri Kosina
SUSE Labs
