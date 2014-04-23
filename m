Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaDWMVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:21:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:36706 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751496AbaDWMVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:21:34 -0400
Date: Wed, 23 Apr 2014 08:21:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiaxing Wang <wangjiaxing@insigma.com.cn>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Stack trace fix and ftrace documentation fixes
Message-ID: <20140423082131.2559e5d4@gandalf.local.home>
In-Reply-To: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
References: <1398006644-5935-1-git-send-email-wangjiaxing@insigma.com.cn>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2014 23:10:42 +0800
Jiaxing Wang <wangjiaxing@insigma.com.cn> wrote:

> The first patch makes trace_stack to skip 4 instead of 3 function 
> return addresses on the stack when ftrace_ops_list_func is used in ftrace,
> and added a function to check for this.
> 
> The second correct the documentation of two functions in ftrace.c
> 
> Jiaxing Wang (2):
>   tracing/trace_stack:Skip 4 instead of 3 when using
>     ftrace_ops_list_func
>   Correct documentation of ftrace_set_global_filter and
>     ftrace_set_global_notrace
> 
>  kernel/trace/ftrace.c      | 11 +++++++----
>  kernel/trace/trace.h       |  1 +
>  kernel/trace/trace_stack.c |  8 ++++++--
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 

I'm a bit busy right now, but I have this in my todo list to look at.

Thanks,

-- Steve
