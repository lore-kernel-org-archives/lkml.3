Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaKROG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:06:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbaKROG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:06:26 -0500
Date: Tue, 18 Nov 2014 15:06:34 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 08/26 v5] tracing: Do not check return values of
 trace_seq_p*() for mmio tracer
Message-ID: <20141118140634.GD23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050602.001652351@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050602.001652351@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:58:55, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The return values for trace_seq_printf() and friends are going to be
> removed and they will become void functions. The mmio tracer checked
> their return and even did so incorrectly.
> 
> Some of the funtions which returned the values were never checked
> themselves. Removing all the checks simplifies the code.
> 
> Use trace_seq_has_overflowed() and trace_handle_return() where
> necessary instead.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
