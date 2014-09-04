Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbaIDBPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:15:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59475 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaIDBPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:15:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Chen LinX <linx.z.chen@intel.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, yanmin_zhang@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: The set_graph_function and set_graph_notrace file mode should be 0644 instead of 0444
References: <1409725869-4501-1-git-send-email-linx.z.chen@intel.com>
Date: Thu, 04 Sep 2014 10:15:46 +0900
In-Reply-To: <1409725869-4501-1-git-send-email-linx.z.chen@intel.com> (Chen
	LinX's message of "Wed, 3 Sep 2014 14:31:09 +0800")
Message-ID: <87vbp49oe5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On Wed,  3 Sep 2014 14:31:09 +0800, Chen LinX wrote:
> Signed-off-by: Chen LinX <linx.z.chen@intel.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  kernel/trace/ftrace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5916a8e..00e7b9a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4406,10 +4406,10 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
>  	ftrace_create_filter_files(&global_ops, d_tracer);
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -	trace_create_file("set_graph_function", 0444, d_tracer,
> +	trace_create_file("set_graph_function", 0644, d_tracer,
>  				    NULL,
>  				    &ftrace_graph_fops);
> -	trace_create_file("set_graph_notrace", 0444, d_tracer,
> +	trace_create_file("set_graph_notrace", 0644, d_tracer,
>  				    NULL,
>  				    &ftrace_graph_notrace_fops);
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
