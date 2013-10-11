Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3JKMuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:50:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43079 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3JKMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:50:20 -0400
Message-ID: <5257F408.9040503@hitachi.com>
Date: Fri, 11 Oct 2013 21:50:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 11/12] tracing: fix tracing_snapshot kerneldoc
References: <cover.1381445299.git.tom.zanussi@linux.intel.com> <af1e1b69b339a85e11f580af9c3ba6dfa28cb20f.1381445299.git.tom.zanussi@linux.intel.com>
In-Reply-To: <af1e1b69b339a85e11f580af9c3ba6dfa28cb20f.1381445299.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/11 9:48), Tom Zanussi wrote:
> The names of the functions are tracing_snapshot_*, not
> trace_snapshot_* - fix up the kerneldoc to avoid confusion.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

It seems that this is not related this series.
Please send it as a trivial fix patch :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  kernel/trace/trace.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5aa8f80..81d95bf 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -514,7 +514,7 @@ EXPORT_SYMBOL_GPL(__trace_bputs);
>  
>  #ifdef CONFIG_TRACER_SNAPSHOT
>  /**
> - * trace_snapshot - take a snapshot of the current buffer.
> + * tracing_snapshot - take a snapshot of the current buffer.
>   *
>   * This causes a swap between the snapshot buffer and the current live
>   * tracing buffer. You can use this to take snapshots of the live
> @@ -617,9 +617,9 @@ int tracing_alloc_snapshot(void)
>  EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);
>  
>  /**
> - * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
> + * tracing_snapshot_alloc - allocate and take a snapshot of the current buffer.
>   *
> - * This is similar to trace_snapshot(), but it will allocate the
> + * This is similar to tracing_snapshot(), but it will allocate the
>   * snapshot buffer if it isn't already allocated. Use this only
>   * where it is safe to sleep, as the allocation may sleep.
>   *
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


