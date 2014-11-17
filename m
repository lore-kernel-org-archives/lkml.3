Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaKQF67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:58:59 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48720 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaKQF66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:58:58 -0500
Date: Mon, 17 Nov 2014 11:28:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/26 v5] tracing/uprobes: Do not use return values of
 trace_seq_printf()
Message-ID: <20141117055850.GD12682@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20141115045847.712848224@goodmis.org>
 <20141115050602.333705855@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20141115050602.333705855@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111705-4790-0000-0000-000004FB15FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2014-11-14 23:58:57]:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The functions trace_seq_printf() and friends will soon no longer have
> return values. Using trace_seq_has_overflowed() and trace_handle_return()
> should be used instead.
> 
> Link: http://lkml.kernel.org/r/20141114011411.693008134@goodmis.org
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks good to me.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
-- 
Thanks and Regards
Srikar Dronamraju

