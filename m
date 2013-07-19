Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab3GSOzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:55:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSOzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:55:23 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=bAxGbWVPFxEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tWpoTtv6JSwA:10 a=20KFwNOVAAAA:8 a=JouN1uCKAAAA:8 a=VbGkPNokYR0Os2Sqno8A:9 a=QEXdDO2ut3YA:10 a=24jZLAgK8hIA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374245722.3356.10.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: Kill trace_array->waiter
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 10:55:22 -0400
In-Reply-To: <20130719142036.GA1594@redhat.com>
References: <20130719142036.GA1594@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 16:20 +0200, Oleg Nesterov wrote:
> Trivial. trace_array->waiter has no users since 6eaaa5d5
> "tracing/core: use appropriate waiting on trace_pipe".

Thanks Oleg, I think this can still be applied for 3.11.

-- Steve

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 4a4f6e1..f849e85 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -214,7 +214,6 @@ struct trace_array {
>  	struct dentry		*event_dir;
>  	struct list_head	systems;
>  	struct list_head	events;
> -	struct task_struct	*waiter;
>  	int			ref;
>  };
>  


