Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaCTDBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:01:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23231 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750737AbaCTDBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:01:38 -0400
Date: Wed, 19 Mar 2014 23:01:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v6 2/3] Tracepoint API doc update: data argument
Message-ID: <20140319230132.5dc57068@gandalf.local.home>
In-Reply-To: <1395268262-31224-3-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395268262-31224-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1395268262-31224-3-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 18:31:01 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Describe the @data argument (probe private data).

As you probably noticed, I added your previous patch to my tree.
You don't need to keep this with your patches.

-- Steve

> 
> Fixes: 38516ab59fbc "tracing: Let tracepoints have data passed to tracepoint callbacks"
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/tracepoint.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index f27e5f0..2e4bfcb 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -370,6 +370,7 @@ tracepoint_add_probe(const char *name, void *probe, void *data)
>   * tracepoint_probe_register -  Connect a probe to a tracepoint
>   * @name: tracepoint name
>   * @probe: probe handler
> + * @data: probe private data
>   *
>   * Returns 0 if ok, error value on error.
>   * The probe address must at least be aligned on the architecture pointer size.
> @@ -412,6 +413,7 @@ tracepoint_remove_probe(const char *name, void *probe, void *data)
>   * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
>   * @name: tracepoint name
>   * @probe: probe function pointer
> + * @data: probe private data
>   *
>   * We do not need to call a synchronize_sched to make sure the probes have
>   * finished running before doing a module unload, because the module unload

