Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3JEAw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 20:52:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59838 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751307Ab3JEAw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 20:52:57 -0400
Date: Fri, 4 Oct 2013 20:52:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] trace: Make UPROBES depend on PERF_EVENTS
Message-ID: <20131004205253.64dc04c9@gandalf.local.home>
In-Reply-To: <1380922788-23112-5-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
	<1380922788-23112-5-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Oct 2013 14:39:46 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> UPROBES need the perf events code, so add a dependency
> from PERF_EVENTS to UPROBES.

Can you please be a bit more specific on what uprobes requires of perf?
That is, what part of the perf events code is needed, and why?

-- Steve

> 
> Cc: rostedt@goodmis.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/trace/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 015f85a..8639819 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -424,6 +424,7 @@ config UPROBE_EVENT
>  	bool "Enable uprobes-based dynamic events"
>  	depends on ARCH_SUPPORTS_UPROBES
>  	depends on MMU
> +	depends on PERF_EVENTS
>  	select UPROBES
>  	select PROBE_EVENTS
>  	select TRACING

