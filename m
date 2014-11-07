Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaKGO6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:58:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:50567 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750919AbaKGO6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:58:40 -0500
Date: Fri, 7 Nov 2014 09:58:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Jiri Kosina <trivial@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] kernel: trace: fix typo
Message-ID: <20141107095820.6128a830@gandalf.local.home>
In-Reply-To: <1415372024-16708-1-git-send-email-frans.klaver@xsens.com>
References: <1415372024-16708-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014 15:53:44 +0100
Frans Klaver <frans.klaver@xsens.com> wrote:

> s,produciton,production
> 
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8a52839..f3ef80c 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2028,7 +2028,7 @@ void trace_printk_init_buffers(void)
>  	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");
>  	pr_warning("**                                                      **\n");
>  	pr_warning("** This means that this is a DEBUG kernel and it is     **\n");
> -	pr_warning("** unsafe for produciton use.                           **\n");
> +	pr_warning("** unsafe for production use.                           **\n");

Hah!

With such a big annoying message like that, with several people that
have mentioned this to me (both good and bad), nobody noticed this typo!

Probably was so big that a little thing like this was hard to see.

>  	pr_warning("**                                                      **\n");
>  	pr_warning("** If you see this message and you are not debugging    **\n");
>  	pr_warning("** the kernel, report this immediately to your vendor!  **\n");


Thanks!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
