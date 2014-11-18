Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaKROSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:18:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbaKROSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:18:09 -0500
Date: Tue, 18 Nov 2014 15:18:17 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 12/26 v5] tracing: Remove return values of most
 trace_seq_*() functions
Message-ID: <20141118141817.GG23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050602.655414633@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050602.655414633@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:58:59, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The trace_seq_printf() and friends are used to store strings into a buffer
> that can be passed around from function to function. If the trace_seq buffer
> fills up, it will not print any more. The return values were somewhat
> inconsistant and using trace_seq_has_overflowed() was a better way to know
> if the write to the trace_seq buffer succeeded or not.
> 
> Now that all users have removed reading the return value of the printf()
> type functions, they can safely return void and keep future users of them
> from reading the inconsistent values as well.
> 
> Link: http://lkml.kernel.org/r/20141114011411.992510720@goodmis.org
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
