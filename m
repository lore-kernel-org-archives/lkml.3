Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaB0Qe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:34:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44172 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752404AbaB0Qez convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:34:55 -0500
Date: Thu, 27 Feb 2014 11:34:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: Re: [PATCH 23/46] kernel: Mark function as static in trace/ftrace.c
Message-ID: <20140227113453.29e1cb83@gandalf.local.home>
In-Reply-To: <c61532a82efacf805f173a30d53d81bbd09d8dfd.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<c61532a82efacf805f173a30d53d81bbd09d8dfd.1393493277.git.rashika.kheria@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:27:49 +0530
Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Mark function as static in kernel/trace/ftrace.c because it is not used
> outside this file.
> 
> Thin eliminates the following warning in kernel/trace/ftrace.c:
> kernel/trace/ftrace.c:717:5: warning: no previous prototype for ‘ftrace_profile_pages_init’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index cd7f76d..d110d8a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -714,7 +714,7 @@ static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
>  	       FTRACE_PROFILE_HASH_SIZE * sizeof(struct hlist_head));
>  }
>  
> -int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
> +static int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
>  {
>  	struct ftrace_profile_page *pg;
>  	int functions;

