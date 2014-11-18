Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaKROCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:02:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbaKROCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:02:44 -0500
Date: Tue, 18 Nov 2014 15:02:51 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 07/26 v5] kprobes/tracing: Use trace_seq_has_overflowed()
 for overflow checks
Message-ID: <20141118140251.GC23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050601.853777652@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050601.853777652@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:58:54, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Instead of checking the return value of trace_seq_printf() and friends
> for overflowing of the buffer, use the trace_seq_has_overflowed() helper
> function.
> 
> This cleans up the code quite a bit and also takes us a step closer to
> changing the return values of trace_seq_printf() and friends to void.
> 
> Link: http://lkml.kernel.org/r/20141114011411.181812785@goodmis.org
> 
> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
