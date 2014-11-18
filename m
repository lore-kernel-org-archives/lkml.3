Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaKROYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:24:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbaKROYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:24:14 -0500
Date: Tue, 18 Nov 2014 15:24:21 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 13/26 v5] tracing: Fix return value of
 ftrace_raw_output_prep()
Message-ID: <20141118142421.GH23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050602.820661984@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050602.820661984@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:59:00, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> If the trace_seq of ftrace_raw_output_prep() is full this function
> returns TRACE_TYPE_PARTIAL_LINE, otherwise it returns zero.
> 
> The problem is that TRACE_TYPE_PARTIAL_LINE happens to be zero!
> 
> The thing is, the caller of ftrace_raw_output_prep() expects a
> success to be zero. Change that to expect it to be
> TRACE_TYPE_HANDLED.
> 
> Link: http://lkml.kernel.org/r/20141114112522.GA2988@dhcp128.suse.cz
> 
> Reminded-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
